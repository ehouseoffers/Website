class SellerListingsController < ApplicationController

  # ensure the user is logged in
  before_filter :redirect_unless_admin, :only => [:index, :edit, :destroy]
  before_filter :authenticate_user!, :only => [:index]
  before_filter :owner_or_admin, :except => [:index, :new, :create]

  layout :minimal_layout

  def index
    @seller_listings = SellerListing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seller_listings }
    end
  end

  # GET /seller_listings/1
  # GET /seller_listings/1.xml
  def show
    @seller_listing = SellerListing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @seller_listing }
    end
  end

  # Step 1a: Form Display
  def new
    set_seller_listing

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @seller_listing }
    end
  end

  # Step 1b: Form Processing (post), send to step 2
  def create
    begin
      # Creates user, address and phone objects needed for seller listing
      seller_listing = SellerListing.wizard_step1(params['seller_listing'])

      # Everybody who becomes owns a seller listing completes the first step (here). However, not everybody will
      # complete the second step. There is valuable data in the second step so we want it if possible, but we also
      # want to create the salesforce data as soon as possible so we can open communication. So, we delay the
      # salesforce creation by an arbitrary period of time (10 minutes) assuming that if the person is going to
      # finish the process, they will do so in the next 10 minutes
      Delayed::Job.enqueue( SalesforceJob.new(seller_listing.id), {:run_at => 10.minutes.from_now})

      sign_out(current_user) if user_signed_in? && current_user.email != params['seller_listing']['user']['email']

      sign_in :user, seller_listing.user if !user_signed_in?

      # Send to second step
      redirect_to [:comp_data, seller_listing]

    rescue Exception => e
      # FIXME -- younker [2010-12-06 13:52]
      # We need to attach params['seller_listing']['address'] data to @seller_listing so we don't lose the form data
      Rails.logger.warn(":: WARN :: seller_listings_controller.create :: #{e.inspect}")
      set_seller_listing
      render :action => :new
    end
  end

  # Step 2a: Comparables Form Display (get)
  def comp_data
    @seller_listing = SellerListing.find(params[:id])
  end

  # Step 2b: Comparables Form Processing (put), send to confirmation
  def update
    seller_listing = SellerListing.find(params[:id])

    respond_to do |format|
      if seller_listing.update_attributes(params[:seller_listing])
        format.html { redirect_to [:thank_you, seller_listing] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => seller_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  def thank_you
    # @seller_listing = SellerListing.find_by_email(params[:id])
    respond_to do |format|
      format.html
      # format.xml  { render :xml => @seller_listing }
    end
  end

  def edit
    # @seller_listing = SellerListing.find(params[:id])
    raise UnsupportedOperation
  end


  # DELETE /seller_listings/1
  # DELETE /seller_listings/1.xml
  def destroy
    @seller_listing = SellerListing.find(params[:id])
    @seller_listing.destroy

    respond_to do |format|
      format.html { redirect_to(seller_listings_url) }
      format.xml  { head :ok }
    end
  end

  private

  # TODO -- younker [2010-11-12 14:35]
  # move this into app controller and allow params to be passed (so we check ownership of an object passed in)
  def owner_or_admin
    listing = SellerListing.find(params[:id])

    unless user_signed_in? && (current_user.id == listing.user_id || current_user.admin?)
      if !user_signed_in?
        Rails.logger.warn("User tried to access page without being signed in")
      elsif current_user.id != listing.user_id
        Rails.logger.warn("#{current_user.to_s} tried to access a page that belongs to #{listing.user.to_s}")
      elsif !current_user.admin?
        Rails.logger.warn("#{current_user.to_s} needs to be an admin to access this page")
      end

      flash[:error] = 'Sorry, but you are not permitted to view that page.'
      redirect_to new_seller_listing_path
    end
  end
end
