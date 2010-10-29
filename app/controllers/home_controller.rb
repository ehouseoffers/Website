class HomeController < ApplicationController

  # before_filter { |app_cont| app_cont.active_section(:home) }

  def home
    active_section(:home)
    if user_signed_in?
      @seller_listing = SellerListing.new(:user_id => current_user.id)
    else
      @seller_listing = SellerListing.new()
      @seller_listing.user = User.new
    end
  end
  
  def about
  end
  
  def terms
  end
end
