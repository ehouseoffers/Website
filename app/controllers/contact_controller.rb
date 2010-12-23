class ContactController < ApplicationController
  before_filter :set_seller_listing, :only => [:index, :new, :show]

  layout :layout

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

    success = false
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

      success = true
    end

    respond_to do |format|
      if success
        format.html { redirect_to contact_path(:thank_you) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
        format.json { render :json => @message.to_json }
      else
        format.html do
          set_seller_listing()
          render :action => 'new'
        end
        format.xml  { render :xml => @message.errors, :status => :internal_server_error }
        format.json { render :json => @message.errors, :status => :internal_server_error }
      end
    end
  end


  def show
  end
end
