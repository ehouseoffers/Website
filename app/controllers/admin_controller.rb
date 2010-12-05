class AdminController < ApplicationController
  before_filter :redirect_unless_admin

  def index
  end

  def become
    u = User.find(params[:id])
    sign_in(:user, u)
    flash[:notice] = "Logged in as #{u.name}"
    redirect_to root_path
  end

end
