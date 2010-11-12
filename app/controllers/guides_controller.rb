class GuidesController < ApplicationController

  before_filter { |app_cont| app_cont.active_section(:guides) }

  # Admin Only!
  before_filter :authenticate_user!, :except => [:index, :show]

  # InheritedResources::Base should inherit from ApplicationController, so we should be able to say
  #   class GuidesController < InheritedResources::Base
  # and get all of ApplicationController's methods. However, for some reason this was not the case so
  # we are pulling in all of the inherited resource functionality by simply calling...
  inherit_resources

  before_filter :set_seller_listing,  :only => [:index, :show]

  def index
    @guides = Guide.paginate :page => params[:page], :order => 'created_at desc'
    @other_guides = Guide.where("id not in ('?')", @guides.collect{|g| g.id}).order('created_at desc')
  end

  def show
    @guide = Guide.find_by_title_for_url(params[:id]) || Guide.find_by_id(params[:id])
    @other_guides = Guide.where("id != '?'", @guide.id).order('created_at desc')
  end

  def edit
    @guide = Guide.find_by_title_for_url(params[:id]) || Guide.find_by_id(params[:id])
    edit!
  end
  
  def create
    # No, we don't pass this in the form
    params[:guide].merge!(:user_id => current_user.id)
    create!(:notice => "The '#{params['guide']['title']}' article was created successfully." ) { guide_path(@guide.title_for_url) }
  end

  def update
    @guide = Guide.find_by_title_for_url(params[:id]) || Guide.find_by_id(params[:id])
    update!(:notice => "Changes to the '#{params['guide']['title']}' article have been saved." ) { guide_path(@guide.title_for_url) }
  end

end
