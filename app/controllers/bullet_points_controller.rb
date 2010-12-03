class BulletPointsController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  layout :layout

  def new
    @bullet_point = BulletPoint.new
    @bullet_point.context    = params[:context]    if params[:context].present?
    @bullet_point.context_id = params[:context_id] if params[:context_id].present?
    new!
  end

  # Show an edit form with all the Q&As for a context
  def edit_collection
    id = params[:context_id]
    klass = params[:context].classify
    @objects = BulletPoint.where(:context_id => id, :context => klass)
    @context = ModelHelper.object_for(id,klass)
  end

end
