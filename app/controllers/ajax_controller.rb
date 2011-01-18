class AjaxController < ApplicationController
  ssl_allowed :placefinder_by_zip

  def placefinder_by_zip
    pf = Placefinder.new(:postal => params[:zip])

    if pf.call_api
      render :json => { :city => pf.city, :state => pf.state, :zip => pf.zip }, :status => 200
    else
      render :text => pf.error_message, :status => 500
    end
  end
end
