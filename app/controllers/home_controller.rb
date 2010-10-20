class HomeController < ApplicationController
  # before_filter :set_section

  before_filter { |app_cont| app_cont.active_section(:home) }

  def welcome
  end

end
