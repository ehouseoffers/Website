class SellerListingsController < ApplicationController
  ssl_required :show, :new, :create, :homeoffer2, :update, :edit, :homeoffer3

  # ensure the user is logged in
  before_filter :redirect_unless_admin, :only => [:index, :edit, :destroy]
  before_filter :authenticate_user!, :only => [:index]
  before_filter :owner_or_admin, :except => [:index, :new, :create]

  layout :minimal

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

      # Everybody who creates a new seller listing gets here, completion of the first step. However, not everybody
      # will complete the second step. There is valuable data in the second step so we want it if possible, but we
      # also want to create the salesforce data as soon as possible so we can open communication. So, we delay the
      # salesforce creation by an arbitrary period of time assuming that if the person is going to finish the process,
      # they will do so in the next n minutes
      Delayed::Job.enqueue(DelayedJobs::RouteNewListing.new(seller_listing.id), {:run_at => 6.minutes.from_now})

      sign_out(current_user) if user_signed_in? && current_user.email != params['seller_listing']['user']['email']
      sign_in :user, seller_listing.user if !user_signed_in?

      # Send to second step
      redirect_to home_offer_2_path(seller_listing.id)

    rescue Exception => e
      # FIXME -- younker [2010-12-06 13:52]
      # We need to attach params['seller_listing']['address'] data to @seller_listing so we don't lose the form data
      Rails.logger.warn(":: WARN :: seller_listings_controller.create :: #{e.inspect}")
      set_seller_listing
      render :action => :new
    end
  end

  # Step 2a: Comparables Form Display (get)
  def homeoffer2
    @seller_listing = SellerListing.find(params[:id])
  end

  # Step 2b: Comparables Form Processing (put), send to confirmation
  def update
    seller_listing = SellerListing.find(params[:id])

    respond_to do |format|
      if seller_listing.update_attributes(params[:seller_listing])
        format.html { redirect_to home_offer_3_path(seller_listing.id, :protocol => 'https') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => seller_listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  def homeoffer3
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
      redirect_to new_home_offer_path
    end
  end
end
