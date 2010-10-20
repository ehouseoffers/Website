class ApplicationController < ActionController::Base
  protect_from_forgery

  # make these available to the views
  helper_method :active_section?

  def active_section(section)
    @active_section = section
  end

  def active_section?(section)
    @active_section && @active_section.to_s.eql?(section)
  end
end
