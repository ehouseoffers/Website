class HomeController < ApplicationController

  before_filter { |app_cont| app_cont.active_section(:home) }

  def welcome
  end

end
