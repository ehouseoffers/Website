class ReasonsToSellController < ApplicationController
  before_filter { |app_cont| app_cont.active_section(:reasons) }

  before_filter :set_seller_listing,  :only => [:index]

end
