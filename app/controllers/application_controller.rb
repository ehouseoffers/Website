class ApplicationController < ActionController::Base
  protect_from_forgery

  # make these available to the views
  helper_method :active_section?

  def active_section(section)
    @active_section = section
  end

  def active_section?(section)
    @active_section && @active_section.to_s.eql?(section)
  end

  # Because of the widespead use of the 'seller_listings/form' partial, we need a @seller_listing object on
  # probably 80% of our pages. Additionally, that object needs to have user info when possible to pre-populate
  # the fields
  def set_seller_listing
    if user_signed_in?
      @seller_listing = SellerListing.new(:user_id => current_user.id)
    else
      @seller_listing = SellerListing.new()
      @seller_listing.user = User.new
    end
  end

end

