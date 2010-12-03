class SocialProfilesController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  layout :layout

  def new
    @social_profile = SocialProfile.new
    @social_profile.context    = params[:context]    if params[:context].present?
    @social_profile.context_id = params[:context_id] if params[:context_id].present?
    new!
  end

  # Show an edit form with all the Q&As for a context
  def edit_collection
    id = params[:context_id]
    klass = params[:context].classify
    @objects = SocialProfile.where(id, klass)
    @context = ModelHelper.object_for(id,klass)
  end

  def destroy
    destroy!{ :back }
  end

end
