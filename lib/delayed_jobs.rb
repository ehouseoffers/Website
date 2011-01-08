require 'ostruct'

# Anything that needs to be delayed should go here. The exception is salesforce_job.rb which predates this and is
# it's own beast, not worth refactoring to fit in here right now. For more information on delayed_job, see:
#   http://railscasts.com/episodes/171-delayed-job
#   https://github.com/collectiveidea/delayed_job
class DelayedJobs
  class Salesforce
    ##
    ## No Buyer for Zip
    ##
    def self.no_buyer_for_zip(seller_listing, send_now=false)
      job = DelayedJobs::Salesforce::NoBuyerForZip.new(seller_listing.id)

      # Business Rules dictate this email should always go out at 6pm the day following their contacting.
      # Thus send_now is meant only for testing/development
      if Rails.env.eql?('development') && send_now
        Rails.logger.debug(":: Debug :: overriding :run_at and setting up delayed job now")
        Delayed::Job.enqueue(job)
      else
        # There has to be an easier way to do this, but I can't figure out how to modify a Time obj
        tomorrow = 1.day.from_now
        six_pm_tomorrow = Time.local(tomorrow.year, tomorrow.month, tomorrow.day, 18)
        Delayed::Job.enqueue(job, {:run_at => six_pm_tomorrow})
      end
    end
    class NoBuyerForZip < Struct.new(:seller_listing_id)
      def perform
        sl = SellerListing.find(seller_listing_id)
        mail = Mailer.no_sforce_buyer_for_zip(sl)
        mail.deliver
      end
    end


    ##
    ## New Seller Confirmation
    ##
    def self.new_seller_confirmation(seller_listing)
      Delayed::Job.enqueue(DelayedJobs::Salesforce::NewSellerConfirmation.new(seller_listing.id))
    end
    class NewSellerConfirmation < Struct.new(:seller_listing_id)
      def perform
        sl = SellerListing.find(seller_listing_id)
        mail = Mailer.new_seller_confirmation(sl)
        mail.deliver
      end
    end


    ##
    ## Buyer Lead Notification
    ##
    def self.buyer_lead_notification(seller_listing, buyer_emails)
      Delayed::Job.enqueue(DelayedJobs::Salesforce::BuyerLeadNotification.new(seller_listing.id, buyer_emails))
    end
    class BuyerLeadNotification < Struct.new(:seller_listing_id, :buyer_emails)
      def perform
        sl = SellerListing.find(seller_listing_id)
        buyer_emails.each do |recipient|
          mail = Mailer.buyer_lead_notification(recipient, sl)
          mail.deliver
        end
      end
    end

  end
end
