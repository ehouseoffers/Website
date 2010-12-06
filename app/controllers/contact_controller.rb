class ContactController < ApplicationController

  before_filter :set_seller_listing, :only => [:index, :new, :show]

  # Show the contact form
  def index
    @message = Message.new
    render :action => 'new'
  end

  def new
    @message = Message.new
  end

  # Send the contact email to us and a confirmation to the user; redirect back to index
  def create
    @message = Message.new(params[:message])

    if @message.valid?
      # 1. If signed in, the contact form didn't give them these fields, so fill them in now since Message requires them
      if user_signed_in?
        @message.email = current_user.email
        @message.name = current_user.name
      end

      # 2. Send us their contact email
      ContactMailer.send_us_their_email(@message).deliver

      # 3. Send the user an email letting them know we received their contact
      ContactMailer.user_contact_confirmation(@message).deliver    

      redirect_to contact_path(:thank_you)
    else
      set_seller_listing()
      render :action => 'new'
    end
  end


  def show
  end
end
