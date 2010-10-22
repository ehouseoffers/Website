class ContactMailer < ActionMailer::Base
  include ActiveModel::Validations
  
  # Attachments
  # attachments["emily.jpg"] = File.read("#{Rails.root}/public/images/e.jpg")  

  # When a user wants to contact us, this is the method that is used to send us their message.
  def send_us_their_email(message)
    @message = message
    mail :to      => 'contact@ehouseoffers.com',
         :from    => message.from,
         :subject => message.subject
  end

  # When a user has sent an email, this method will send that user an email saying their message was sent
  def user_contact_confirmation(message)
    @message = message
    mail :to      => message.email,
         :from    => 'noreply@ehouseoffers.com',
         :subject => 'eHouseOffers.com : Your message has been received!'
  end
end


