class TrendsController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:trends) }

  before_filter :set_seller_listing,  :only => [:index]

end
