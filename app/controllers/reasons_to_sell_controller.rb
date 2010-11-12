class ReasonsToSellController < ApplicationController

  before_filter :redirect_unless_admin, :except => [:index, :show]
  before_filter :authenticate_user!,    :except => [:index, :show]
  before_filter :set_seller_listing,    :only => [:index, :show]

  before_filter { |app_cont| app_cont.active_section(:reasons) }

  def index
    @reasons = ReasonToSell.paginate :page => params[:page], :order => 'created_at desc'
    @slider_reasons = ReasonToSell.where("id not in ('?')", @reasons.collect{|r| r.id}).order('created_at desc')
  end

  def new
    @reason = ReasonToSell.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reason }
    end
  end
  
  def create
    # No, we don't pass this in the form
    params[:reason_to_sell].merge!(:user_id => current_user.id)

    reason = ReasonToSell.new(params[:reason_to_sell])

    respond_to do |format|
      if reason.save
        format.html { redirect_to(object_path(reason), :notice => "#{reason.title} was successfully created.") }
        format.xml  { render :xml => reason, :status => :created, :location => reason }
      else
        @reason = reason
        format.html { render :action => "new" }
        format.xml  { render :xml => reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @reason = ReasonToSell.find_by_title_for_url(params[:id]) || ReasonToSell.find_by_id(params[:id])
    @other_reasons = ReasonToSell.where("id != '?'", @reason.id).order('created_at desc')
  end

  def edit
    @reason = ReasonToSell.find_by_title_for_url(params[:id]) || ReasonToSell.find_by_id(params[:id])
  end

  def update
    @reason = ReasonToSell.find_by_title_for_url(params[:id]) || ReasonToSell.find_by_id(params[:id])

    # No, we don't pass this in the form
    params[:reason_to_sell].merge!(:user_id => current_user.id)

    respond_to do |format|
      if @reason.update_attributes(params[:reason_to_sell])
        format.html { redirect_to(object_path(@reason), :notice => "#{@reason.title} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  def email_image
    flash[:error] = 'this is not yet implemented'
    redirect_to :back
  end
end
