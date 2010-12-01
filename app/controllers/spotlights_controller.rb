class SpotlightsController < ApplicationController

  before_filter :redirect_unless_admin, :except => [:index, :show]
  before_filter :set_seller_listing,    :only => [:index, :show]
  before_filter { |app_cont| app_cont.active_section(:spotlights) }

  inherit_resources

  def index
    @spotlight = Spotlight.first
    @other_spotlights = Spotlight.where("id != ?", @spotlight.id).paginate :page => params[:page], :order => 'created_at desc', :per_page => 5

    respond_to do |format|
      format.html { render :template => 'spotlights/show' }
      format.xml  { render :xml => @spotlight }
    end
  end

  def show
    @spotlight = Spotlight.find_by_title_for_url(params[:id]) || Spotlight.find_by_id(params[:id])
    @other_spotlights = Spotlight.where("id != ?", @spotlight.id).paginate :page => params[:page], :order => 'created_at desc', :per_page => 5
  
    respond_to do |format|
      format.html
      format.xml  { render :xml => @spotlight }
    end
  end

  def update
    begin
      # Update additional pieces: Q&A, bullet points and social contacts
      Qa.update(params[:qa].keys, params[:qa].values)
      BulletPoint.update(params[:bullet_point].keys, params[:bullet_point].values)
      SocialProfile.update(params[:social_profile].keys, params[:social_profile].values)

      @spotlight = Spotlight.find_by_title_for_url(params[:id]) || Spotlight.find_by_id(params[:id])
      @spotlight.update_attributes(params[:spotlight])
    
      respond_to do |format|
        format.html { redirect_to(spotlight_path(@spotlight.title_for_url), :notice => "#{@spotlight.title} was successfully updated.") }
        format.xml  { render :xml => @spotlight, :status => :created, :location => @spotlight }
      end
    rescue Exception => e
      format.html { render :action => "new" }
      format.xml  { render :xml => @spotlight.errors, :status => :unprocessable_entity }
    end
  end

  # def destroy
  #   flash[:error] = 'Sorry, we do not destroy blog entries.'
  #   redirect_to :back
  # end


end
