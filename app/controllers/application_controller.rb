class ApplicationController < ActionController::Base
  protect_from_forgery

  # make these available to the views
  helper_method :active_section?, :object_path

  def layout
    request.xhr? ? false : 'application'
  end

  def minimal_layout
    @frame = :minimal
    layout
  end


  def active_section(section)
    @active_section = section
  end

  def active_section?(section)
    @active_section && @active_section.to_s.eql?(section)
  end

  # for a given object, say a Guides object, get the show path for it (i.e. guides_path())
  def object_path(obj)
    case obj.class.name.intern
    when :ReasonToSell then reason_path(obj.title_for_url)
    else
      path = "#{obj.class.name.downcase}_path"
      obj.respond_to?(:title_for_url) ? send(path, obj.title_for_url) : send(path, obj)
    end
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

