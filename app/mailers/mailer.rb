class Mailer < ActionMailer::Base
  include ActiveModel::Validations
  include ApplicationHelper
  
  # layout 'email'

  # Attachments
  # attachments["emily.jpg"] = File.read("#{Rails.root}/public/images/e.jpg")  

  # When a user wants to contact us, this is the method that is used to send us their message.
  def send_us_their_email(message)
    @message = message
    @title = message.subject
    mail :to      => 'contact@ehouseoffers.com',
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
end


