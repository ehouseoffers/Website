class GuidesController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:guides) }

  def index
  end

end
