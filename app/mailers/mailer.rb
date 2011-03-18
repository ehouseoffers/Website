class Mailer < ActionMailer::Base
  include ActiveModel::Validations
  include ApplicationHelper

  
  # Currently specific to the blogs_controller.email_image
  # Args should contain:
  #  
  def email_image(recipient_email, recommended_by_email, blog)
    @recipient_email = recipient_email
    @recommended_by_email = recommended_by_email
    @blog = blog
    @tracking_params = {:utm_source => 'share', :utm_medium => 'email', :utm_campaign => 'share+article+with+friend'}

    attachments[blog.photo_file_name] = File.read(blog.photo.path(:medium))
    mail :to      => [recipient_email, recommended_by_email],
         :bcc     => 'ehouseoffers@gmail.com, sam@ehouseoffers.com',
         :from    => "share@ehouseoffers.com",
         :subject => "#{recommended_by_email} Has Recommended an Article for You"
  end

  # When a user wants to contact us, this is the method that is used to send us their message.
  def send_us_their_email(message)
    @message = message
    @title = message.subject
    mail :to      => KEYS['our_email'],
         :from    => "#{@message.name} <#{@message.email}>",
         :subject => message.subject
  end

  # When a user has sent an email, this method will send that user an email saying their message was sent
  def user_contact_confirmation(message)
    @message = message
    @title = 'eHouseOffers :: Your message has been received!'
    mail :to      => message.email,
         :from    => "eHouseOffers <#{KEYS['smtp']['noreply']}>",
         :subject => @title
  end

  # - Setup via delayed_jobs.
  # - Send email to a new seller listing (customer) who wants to sell a home in an zip code for which
  #   we do NOT have a buyer
  def no_sforce_buyer_for_zip(seller_listing)
    @seller_listing = seller_listing
    @tracking_params = {:utm_source => 'seller', :utm_medium => 'email', :utm_campaign => 'no+buyer+in+area'}
    mail :to      => "#{seller_listing.user.name} <#{seller_listing.user.email}>",
         :from    => 'Chris Richter <christopher@ehouseoffers.com>',
         :bcc     => 'ehouseoffers@gmail.com, sam@ehouseoffers.com',
         :subject => "Offer on your Home in #{seller_listing.address.city}"
  end
  
  # Send an email to a new seller. This is the action to take when salesforce_job.perform successfully ties a
  # seller to a buyer in salesforce and creates the new lead for that seller
  def new_seller_confirmation(seller_listing)
    @seller_listing = seller_listing
    @tracking_params = {:utm_source => 'seller', :utm_medium => 'email', :utm_campaign => 'offer+request+confirmation'}
    mail :to      => "#{seller_listing.user.name} <#{seller_listing.user.email}>",
         :from    => 'Chris Richter <christopher@ehouseoffers.com>',
         :bcc     => 'ehouseoffers@gmail.com, sam@ehouseoffers.com, chris@ehouseoffers.com',
         :subject => 'Home Offer Request Confirmation'
  end

  # Send our new sellers some information about affiliate services.
  # See DelayedJobs::Salesforce.new_seller_affiliate_services for more info on when these are sent.
  def new_seller_affiliate_services(seller_listing)
    @seller_listing = seller_listing
    @tracking_params = {:utm_source => 'seller', :utm_medium => 'email', :utm_campaign => 'partner+credit+repair'}
    mail :to      => "#{seller_listing.user.name} <#{seller_listing.user.email}>",
         :from    => 'Chris Richter <christopher@ehouseoffers.com>',
         :bcc     => 'ehouseoffers@gmail.com, sam@ehouseoffers.com',
         :subject => "3 Credit Repair Tips for Home Sellers in #{seller_listing.address.city}"
  end

  # Send an email to all buyers associated with a zip code for a recently added seller. This action is a direct result
  # of salesforce_job.perform completing successfully
  def buyer_lead_notification(recipients, seller_listing)
    @seller_listing = seller_listing
    @tracking_params = {:utm_source => 'buyer', :utm_medium => 'email', :utm_campaign => 'lead+notification'}
    mail :to      => recipients,
         :from    => 'Motivated Seller <motivated-seller@ehouseoffers.com>',
         :bcc     => 'ehouseoffers@gmail.com, sam@ehouseoffers.com',
         :subject => "eHouseOffers Motivated Seller - #{seller_listing.user.name}"
  end
end


