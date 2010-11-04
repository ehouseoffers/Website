class SpotlightController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:spotlighters) }

  before_filter :set_seller_listing,  :only => [:index]

end
