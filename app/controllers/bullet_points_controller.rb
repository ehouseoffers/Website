class BulletPointsController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  def new
    @bullet_point = BulletPoint.new
    @bullet_point.context    = params[:context]    if params[:context].present?
    @bullet_point.context_id = params[:context_id] if params[:context_id].present?
    new!
  end
end
