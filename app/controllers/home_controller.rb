class HomeController < ApplicationController

  layout :layout
  # before_filter { |app_cont| app_cont.active_section(:home) }

  def home
    active_section(:home)
    set_seller_listing
  end
  
  def what_we_do
  end

  def about
    set_seller_listing
    @message = Message.new
  end
  
  def terms
  end

  def become_a_buyer
    @message = Message.new
    render :template => 'contact/new'
  end
  
  def generate_url_friendly_string
    render :text => params[:string].make_url_friendly
  end
end
