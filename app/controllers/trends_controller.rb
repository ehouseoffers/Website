class TrendsController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:trends) }

  def index
  end

end
