require 'ostruct'

# http://railscasts.com/episodes/171-delayed-job
class SalesforceJob < Struct.new(:seller_listing_id)
  LEAD         = 'Lead'
  LEAD_SOURCE  = 'Web'
  LEAD_COUNTRY = 'USA'   # Hard-coded b/c it's all we support right now
  LEAD_COMPANY = '28dev' # Bogus until we can switch to busines-to-customer salesforce account

  def perform
    Rails.logger.info("+ Begin delayed job")
    binding = RForce::Binding.new KEYS['salesforce']['base']
    binding.login KEYS['salesforce']['username'], KEYS['salesforce']['password'] + KEYS['salesforce']['token']

    sl = SellerListing.find(seller_listing_id)

    # User, address and phone info must be here to create a seller listing
    lead = [
      :type,       LEAD,
      :LeadSource, LEAD_SOURCE,
      :Country,    LEAD_COUNTRY,
      :Company,    LEAD_COMPANY,
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
    account_id = SalesforceJob.account_owner_for_zip(binding, sl.address.zip)
    lead.push(:Owned_by_Account__c, account_id) if account_id.present?

    # Create Lead!
    lead = binding.create :sObject => lead
    resp = SalesforceJob.munge_create_results(lead)

    if resp.ok?
      sl.salesforce_lead_id = resp.salesforce_lead_id
      sl.salesforce_lead_owner_id = account_id
      sl.save!
      Rails.logger.info("+ SUCCESS -- For seller listing #{sl.id}, a salesforce lead was created with id #{sl.salesforce_lead_id} and is owned by the salesforce account with id #{sl.salesforce_lead_owner_id}.")
    else
      raise "#{resp.code} -- #{resp.error}"
    end
  end
  
  # private
  
  # search salesforce accounts for somebody who owns a given zip
  def self.account_owner_for_zip(binding, zip)
    results = binding.search :searchString => "find {*#{zip}*} in postal_codes fields returning account(id)"
    resp = SalesforceJob.munge_search_results(results, zip)
    resp.ok? ? resp.salesforce_account_id : null
  end

  def self.munge_search_results(resp, zip)
    if resp[:Fault].present?
      OpenStruct.new('ok?' => false, :code => resp[:Fault][:faultcode], :error => resp[:Fault][:faultstring])
    else
      begin
        records = resp[:searchResponse][:result][:searchRecords]
        if records.is_a?(Array)
          records_str = records.collect{|r| r[:record][:Id]}.join(', ')
          record_id = records.first[:record][:Id]
          err = "More than one account has claimed area code #{zip}. The following Salesforce Account ids own this zip: #{records_str}. Picking the first entry (#{record_id}) to assign lead to."
          Rails.logger.warn(":: WARN :: salesforce_job.munge_search_results -- #{err}")
          OpenStruct.new('ok?' => true, :salesforce_account_id => record_id)
        else
          OpenStruct.new('ok?' => true, :salesforce_account_id => records[:record][:Id])
        end
      rescue => e
        Rails.logger.warn(":: Exception :: #{e.inspect}")
        err = "Unknown data structure returned: #{resp.inspect} (#{e})"
        Rails.logger.warn(":: WARN :: salesforce_job.munge_search_results -- #{err}")
        OpenStruct.new('ok?' => false, :code => 'Unknown', :error => err)
      end
    end
  end



  # munge the results of a salesforce object create() request. NOT very scalable at all!
  def self.munge_create_results(resp)
    if resp[:Fault].present?
      OpenStruct.new('ok?' => false, :code => resp[:Fault][:detail][:faultcode], :error => lead[:Fault][:faultstring])

    elsif resp[:createResponse].present? && resp[:createResponse][:result].present?
      result = resp[:createResponse][:result]
      if result[:success].eql?("false")
        err = result[:errors].inspect
        Rails.logger.warn(":: WARN :: salesforce_job.munge_create_results -- #{err}")
        OpenStruct.new('ok?' => false, :code => 'Unknown', :error => err)
      else
        OpenStruct.new('ok?' => result[:success], :salesforce_lead_id => result[:id])
      end
    else
      err = "Unknown data structure returned: #{resp.inspect}"
      Rails.logger.warn(":: WARN :: salesforce_job.munge_create_results -- #{err}")
      OpenStruct.new('ok?' => false, :code => 'Unknown', :error => err)
    end
  end
end