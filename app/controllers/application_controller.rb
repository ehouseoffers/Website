class ApplicationController < ActionController::Base
  protect_from_forgery

  # make these available to the views
  helper_method :active_section?, :construct_blog_path

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

  def redirect_unless_admin
    unless user_signed_in? && current_user.admin?
      flash[:error] = 'You are not permitted to view that page.'
      redirect_to (request.env["HTTP_REFERER"].present? ? request.env["HTTP_REFERER"] : root_path)
    end
  end

  def construct_blog_path(obj, action='index', context=nil)
    if obj.present?
      raise "Invalid Context -- #{obj.context}" unless obj.valid_context?
      context = obj.context
    elsif context.present?
      raise "Invalid Context -- #{context}" unless Blog::VALID_CONTEXTS.include?(context.to_s)
    else
      raise "Invalid"
    end
    
    case action.to_s.intern
    when :index, :create, :delete then send("#{context.pluralize}_path")
    when :new, :edit              then send("#{action.to_s}_#{context.singularize}_path")
    when :show, :update           then send("#{context.singularize}_path", obj.respond_to?(:title_for_url) ? obj.title_for_url : obj.id)
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

