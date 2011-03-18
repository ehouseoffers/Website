require 'ostruct'

# http://railscasts.com/episodes/171-delayed-job
class SalesforceJob < Struct.new(:seller_listing_id)
  # Created in prod by me (younker) and I am hard coding it here b/c 1) we are running out of tiem, 2) if we don't find
  # an account to bind this lead to and we already know what our ehouse account is (this one) we should not have to do
  # another sforce api query to get it and 3) we could come up with another way to store this (db) without hard-coding
  # it but whatever. this will work for now.
  EHOUSE_SFORCE_ACCOUNT_ID = KEYS['salesforce']['default_account_id']

  LEAD         = 'Lead'
  LEAD_SOURCE  = 'Web'
  LEAD_COUNTRY = 'USA'   # Hard-coded b/c it's all we support right now

  def perform
    begin
      binding = RForce::Binding.new KEYS['salesforce']['base']
      binding.login KEYS['salesforce']['username'], KEYS['salesforce']['password'] + KEYS['salesforce']['token']

      sl = SellerListing.find(seller_listing_id)

      # User, address and phone info must be here to create a seller listing
      lead = [
        :type,       LEAD,
        :LeadSource, LEAD_SOURCE,
        :Country,    LEAD_COUNTRY,
        :FirstName,  sl.user.first_name,
        :LastName,   sl.user.last_name,
        :Email,      sl.user.email,
        :Phone,      sl.phone_number.number,
        :City,       sl.address.city,
        :State,      sl.address.state,
        :PostalCode, sl.address.zip
      ]

      # Check and see if we have second-step data yet (which is, of course, the entire reason for delaying this
      # job [to give the user enough time to finish step 2])
      lead.push(:EstimatedValue__c,  sl.estimated_value(true).to_s) if sl.estimated_value.present?
      lead.push(:AskingPrice__c,     sl.asking_price(true).to_s)    if sl.asking_price.present?
      lead.push(:LoanAmount__c,      sl.loan_amount(true).to_s)     if sl.loan_amount.present?
      lead.push(:DesiredSellTime__c, sl.time_frame.to_s)            if sl.time_frame.present?
      lead.push(:SellingReason__c,   sl.selling_reason)             if sl.selling_reason.present?

      # Who owns this zip?
      owner_resp = SalesforceJob.account_owner_for_zip(binding, sl)

      if owner_resp.ok?
        account_id = owner_resp.salesforce_account_id
        lead.push(:Owned_by_Account__c, account_id)
      end

      # Create Lead!
      lead = binding.create :sObject => lead
      create_resp = SalesforceJob.munge_create_salesforce_lead_results(lead, sl)

      if create_resp.ok?
        sl.salesforce_lead_id = create_resp.salesforce_lead_id
        sl.salesforce_lead_owner_id = account_id
        sl.save!

        # Now that we sucessfully tied this seller listing to a buyer account in salesforce, send out our new
        # seller listing confirmation email according to the specs outlined here:
        #   https://ehouseoffers.fogbugz.com/default.asp?28 -- seller_offer_request_confirmation.rtf
        # Because we already waited to process this (see seller_listings_controller.create), we send this email
        # out without delay despite what the ticket says. We just use delayed job to make it it's own process
        DelayedJobs::Salesforce.new_seller_confirmation(sl)
        DelayedJobs::Salesforce.new_seller_affiliate_services(sl, true)
        DelayedJobs::Salesforce.buyer_lead_notification(sl, owner_resp.buyer_emails)
      else
        Rails.logger.fatal("Salesforce create lead bombed! create_resp = #{create_resp.inspect}")
      end

    rescue => e
      Rails.logger.fatal("SalesforceJob.perform bombed with the following exception: "+ e)
      raise e
    end
  end
  
  # private
  
  # search salesforce accounts for somebody who owns a given zip
  def self.account_owner_for_zip(binding, seller_listing)
    results = binding.search :searchString => "find {*#{seller_listing.address.zip}*} in postal_codes fields returning account(id, email__c)"
    SalesforceJob.munge_search_results(results, seller_listing)
  end

  # 1) if the search returned a :Fault, log fatal
  # 2) if no record was found, raise RecordNotFound and send email to seller
  # 3) if multiple buyers were found for a zip, pick the first and log a warn
  # 4) if we can't make sense of the response, log fatal and assign to default buyer account
  def self.munge_search_results(resp, seller_listing)
    if resp[:Fault].present?
      Rails.logger.fatal("Salesforce search bombed for seller listing #{seller_listing.id} with: #{resp.inspect}")
      # OpenStruct.new('ok?' => false, :code => resp[:Fault][:faultcode], :error => resp[:Fault][:faultstring])
      OpenStruct.new('ok?' => true,
                     :salesforce_account_id => EHOUSE_SFORCE_ACCOUNT_ID,
                     :salesforce_account_email => KEYS['our_email'],
                     :buyer_emails => KEYS['our_email'])
    else
      begin
        raise RecordNotFound if resp[:searchResponse][:result].nil?

        records = resp[:searchResponse][:result][:searchRecords]
        if records.is_a?(Array)
          emails = records.collect{|r| r[:record][:Email__c]}
          owner = records.first[:record]
          Rails.logger.warn("More than one account has claimed area code #{seller_listing.address.zip}. The following Salesforce Account emails own this zip: #{emails.join(',')}. Picking the first entry (#{owner[:Id]}) to assign lead to.")
          OpenStruct.new('ok?' => true,
                         :salesforce_account_id => owner[:Id],
                         :salesforce_account_email => owner[:Email__c],
                         :buyer_emails => emails)

        elsif record_id = records[:record][:Id]
          OpenStruct.new('ok?' => true,
                         :salesforce_account_id => record_id,
                         :salesforce_account_email => records[:record][:Email__c],
                         :buyer_emails => records[:record][:Email__c].to_a)
        else
          raise 'Unknown data structure'
        end
      rescue RecordNotFound => e
        e.setup_no_buyer_for_zip_email(seller_listing)
        # OpenStruct.new('ok?' => false, :error => "Salesforce buyer account not found for zip #{seller_listing.address.zip}")
        OpenStruct.new('ok?' => true,
                       :salesforce_account_id => EHOUSE_SFORCE_ACCOUNT_ID,
                       :salesforce_account_email => KEYS['our_email'],
                       :buyer_emails => KEYS['our_email'])

      rescue => e
        Rails.logger.warn("Unknown data structure returned for seller listing #{seller_listing.id}. Salesforce search response = #{resp.inspect} (#{e}). Assigning to default eHouse account.")
        OpenStruct.new('ok?' => true,
                       :salesforce_account_id => EHOUSE_SFORCE_ACCOUNT_ID,
                       :salesforce_account_email => KEYS['our_email'],
                       :buyer_emails => KEYS['our_email'])
      end
    end
  end

  # munge the results of a salesforce object create() request. NOT very scalable at all!
  def self.munge_create_salesforce_lead_results(resp, seller_listing)
    begin
      if resp[:Fault].present?
        Rails.logger.fatal("Salesforce was unable to create a new lead for seller listing #{seller_listing.id}. Response = #{resp.inspect}")
        OpenStruct.new('ok?' => false, :code => resp[:Fault][:detail][:faultcode], :error => resp[:Fault][:faultstring])

      else result = resp[:createResponse][:result]
        if result[:success].eql?("false")
          Rails.logger.fatal("Unable to create new salesforce lead for seller listing #{seller_listing.id}. Result = #{result.inspect}")
          OpenStruct.new('ok?' => false, :code => 'Unknown', :error => result[:errors].inspect)
        elsif id = result[:id]
          OpenStruct.new('ok?' => result[:success], :salesforce_lead_id => id)
        else
          raise 'Unexpected data structure'
        end
      end
    rescue => e
      Rails.logger.fatal("Unknown response when attempting to munge salesforce lead creation results. Exception => #{e.inspect}. Response = #{resp.inspect}")
      OpenStruct.new('ok?' => false, :code => 'Unknown', :error => 'Exception raised when trying to munge results')
    end
  end

  class RecordNotFound < Exception
    def setup_no_buyer_for_zip_email(seller_listing)
      # No salesforce buyer for this zip code? Send out an email according to the following:
      # https://ehouseoffers.fogbugz.com/default.asp?28 -- seller_no_buyers_in_area.rtf
      DelayedJobs::Salesforce.no_buyer_for_zip(seller_listing)

      # https://ehouseoffers.fogbugz.com/default.asp?34
      DelayedJobs::Salesforce.new_seller_affiliate_services(seller_listing, false)
    end
  end
end