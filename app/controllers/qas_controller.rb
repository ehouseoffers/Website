class QasController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  layout :layout

  def new
    @qa = Qa.new
    @qa.context    = params[:context]    if params[:context].present?
    @qa.context_id = params[:context_id] if params[:context_id].present?
    new!
  end

  # Show an edit form with all the Q&As for a context
  def edit_collection
    id = params[:context_id]
    klass = params[:context].classify
    @objects = Qa.where(id, klass)
    @context = ModelHelper.object_for(id,klass)
  end

  def destroy
    destroy!{ :back }
  end
end
