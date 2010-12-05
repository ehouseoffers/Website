class Admin::UserAccountsController < ApplicationController
  before_filter :redirect_unless_admin
  layout :layout

  def index
    @users = User.all
  end
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(:back, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
        format.json { user.to_json }
      end
    end
  end
  
end
