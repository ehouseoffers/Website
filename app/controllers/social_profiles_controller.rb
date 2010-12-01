class SocialProfilesController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  def new
    @social_profile = SocialProfile.new
    @social_profile.context    = params[:context]    if params[:context].present?
    @social_profile.context_id = params[:context_id] if params[:context_id].present?
    new!
  end

end
