class SpotlightsController < ApplicationController

  before_filter :redirect_unless_admin, :except => [:index, :show]
  before_filter :set_seller_listing,    :only   => [:index, :show]
  before_filter :set_noindex,           :only   => [:index]
  before_filter { |app_cont| app_cont.active_section(:spotlights) }

  inherit_resources

  def index
    @spotlights = Spotlight.paginate :page => params[:page], :order => 'created_at desc', :per_page => 5
    @other_spotlights = Spotlight.where("id not in ('?')", @spotlights.collect{|s| s.id}).limit(9).order('created_at desc')

    respond_to do |format|
      format.html # index.haml
      format.xml  { render :xml => @spotlights }
    end
  end

  def show
    @spotlight = Spotlight.find_by_title_for_url(params[:id]) || Spotlight.find_by_id(params[:id])
    @other_spotlights = Spotlight.where("id != ?", @spotlight.id).limit(9).order('created_at desc')
  
    respond_to do |format|
      format.html
      format.xml  { render :xml => @spotlight }
    end
  end

  def create
    begin
      @spotlight = Spotlight.new(params[:spotlight])
      @spotlight.save!

      create_new_qas
      create_new_bullet_points
      create_new_social_profiles

      respond_to do |format|
        format.html { redirect_to(@spotlight, :notice => 'Spotlight was successfully created.') }
        format.xml  { render :xml => @spotlight, :status => :created, :location => @spotlight }
      end
    rescue Exception => e
      Rails.logger.warn(":: WARN :: spotlights_controller#create - e = '#{e.inspect}'")
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @spotlight.errors, :status => :unprocessable_entity }
      end
    end
  end



  def update
    @spotlight = Spotlight.find_by_title_for_url(params[:id]) || Spotlight.find_by_id(params[:id])

    begin
      @spotlight.update_attributes(params[:spotlight])

      # Q&A -- update and add new
      Qa.update(params[:qa].keys, params[:qa].values) if params[:qa].present?
      create_new_qas

      # Bullet Points -- update and add new
      BulletPoint.update(params[:bullet_point].keys, params[:bullet_point].values) if params[:bullet_point].present?
      create_new_bullet_points

      SocialProfile.update(params[:social_profile].keys, params[:social_profile].values) if params[:social_profile].present?
      create_new_social_profiles

      respond_to do |format|
        format.html { redirect_to(spotlight_path(@spotlight.title_for_url), :notice => "#{@spotlight.title} was successfully updated.") }
        format.xml  { render :xml => @spotlight, :status => :created, :location => @spotlight }
      end
    rescue Exception => e
      Rails.logger.warn(":: WARN :: spotlights_controller#update - e = '#{e.inspect}'")
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @spotlight.errors, :status => :unprocessable_entity }
      end
    end
  end


  # def destroy
  #   flash[:error] = 'Sorry, we do not destroy blog entries.'
  #   redirect_to :back
  # end


  private

  def create_new_qas
    context = @spotlight.class.name
    context_id = @spotlight.id

    if params[:new_qa].present?
      params[:new_qa].each_pair do |index, qa|
        if qa['question'].present? && qa['answer'].present?
          Qa.new(:context => context, :context_id => context_id,
                :question => qa['question'], :answer => qa['answer']).save!
        end
      end
    end
  end

  def create_new_bullet_points
    context = @spotlight.class.name
    context_id = @spotlight.id

    if params[:new_bp].present?
      params[:new_bp].each_pair do |index, bp|
        if bp['content'].present?
          BulletPoint.new(:context => context, :context_id => context_id, :content => bp['content']).save!
        end
      end
    end
  end

  def create_new_social_profiles
    context = @spotlight.class.name
    context_id = @spotlight.id

    if params[:new_sp].present?
      params[:new_sp].each_pair do |index, sp|
        if sp['website'].present? && sp['username'].present? && sp['url'].present?
          SocialProfile.new(:context => context, :context_id => context_id, :website => sp['website'],
                            :username => sp['username'], :url => sp['url']).save!
        end
      end
    end
  end

end
