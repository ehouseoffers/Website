class ReasonsToSellController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:reasons) }

  def index
  end

end
