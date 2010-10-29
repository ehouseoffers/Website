class SellerListingsController < ApplicationController

  # ensure the user is logged in
  # before_filter :authenticate_user!, :except => [:index]

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
    # @seller_listing = SellerListing.new

    if user_signed_in?
      @seller_listing = SellerListing.new(:user_id => current_user.id)
    else
      @seller_listing = SellerListing.new()
      @seller_listing.user = User.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @seller_listing }
    end
  end

  # Step 1b: Form Processing (post), send to step 2
  def create
    seller_listing = SellerListing.wizard_step1(params['seller_listing'])

    sign_in :user, seller_listing.user if !user_signed_in?

    # TODO -- younker [2010-10-28 23:35]
    # if user_signed_in? && current_user.email != params['seller_listing']['user']['email']
    #   flash[:error] = "this is not for the ucrrently logged in user! Why not?"
    #   redirect_to :back and return
    # end

    # Send to second step
    redirect_to [:comp_data, seller_listing]
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
end
