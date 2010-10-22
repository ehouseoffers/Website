class SpotlightController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:spotlighters) }

  def index
  end
end
