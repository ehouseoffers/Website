class AdminController < ApplicationController
  before_filter :redirect_unless_admin

  def index
    
  end
end
