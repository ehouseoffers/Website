class QasController < ApplicationController
  before_filter :redirect_unless_admin
  inherit_resources

  def new
    @qa = Qa.new
    @qa.context    = params[:context]    if params[:context].present?
    @qa.context_id = params[:context_id] if params[:context_id].present?
    new!
  end

end
