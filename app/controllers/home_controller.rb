class HomeController < ApplicationController

  layout :layout
  # before_filter { |app_cont| app_cont.active_section(:home) }

  def home
    active_section(:home)
    set_seller_listing()
  end
  
  def what_we_do
  end

  def about
  end
  
  def terms
  end
end
