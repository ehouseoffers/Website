class GuidesController < ApplicationController

  # Admin Only!
  before_filter :authenticate_user!, :except => [:index, :show]

  # InheritedResources::Base should inherit from ApplicationController, so we should be able to say
  #   class GuidesController < InheritedResources::Base
  # and get all of ApplicationController's methods. However, for some reason this was not the case so
  # we are pulling in all of the inherited resource functionality by simply calling...
  inherit_resources

  before_filter :set_seller_listing,  :only => [:index, :show]

  def index
    active_section(:guides)
    # index!
    @guides = Guide.order('created_at desc')
  end

  def show
    @guide = Guide.find_by_url_friendly_title(params[:id])
  end
  
  def create
    create! { guide_path(@guide.url_friendly_title) }
    flash.clear
  end

  def update
    update! { guide_path(@guide.url_friendly_title) }
    flash.clear
  end

end
