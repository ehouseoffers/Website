class HomeController < ApplicationController

  # before_filter { |app_cont| app_cont.active_section(:home) }

  def home
    active_section(:home)
    set_seller_listing()
  end
  
  def about
  end
  
  def terms
  end
end
