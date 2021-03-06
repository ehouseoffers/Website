# --------------------------------------------------------------------------------------------------
#
#  NOTE!
#  guides_controller inherits from BlogsController. See guides_controller.rb for the answer to why
#
#--------------------------------------------------------------------------------------------------
class BlogsController < ApplicationController

  # We need construct_blog_path() for respond_to actions
  include ApplicationHelper

  before_filter :redirect_unless_editor, :except => [:index, :show, :email_image]
  before_filter :set_seller_listing,    :only   => [:index, :show]
  before_filter :set_noindex,           :only   => [:index]
  before_filter :setup_for_blog_context
  before_filter :ensure_full_path_name, :only   => [:index]

  def index
    @blogs = Blog.where("context = ?", @context).paginate :page => params[:page], :order => 'created_at desc', :per_page => 5
    @other_blogs = Blog.where("context = ? and id not in ('?')", @context, @blogs.collect{|b| b.id}).limit(9).order('created_at desc')

    respond_to do |format|
      format.html # index.haml relative to controller calling it (could be /guides/index or /blogs/index)
      format.xml  { render :xml => @blogs }
    end
  end

  def new
    @blog = Blog.new(:context => @context)

    respond_to do |format|
      format.html { render :template => "blogs/new"}
      format.xml  { render :xml => @blog }
    end
  end
  
  def create
    # No, we don't pass these in the form
    params[:blog].merge!(:user_id => current_user.id, :context => @context)

    @blog = Blog.new(params[:blog])
    respond_to do |format|
      if @blog.save
        format.html { redirect_to(construct_blog_path(@blog, :show), :notice => "#{@blog.title} was successfully created.") }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        set_seller_listing
        setup_for_blog_context
        @blog.context = @context
        format.html { render :template => "blogs/new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @blog = Blog.find_by_title_for_url(params[:id]) || Blog.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound unless @blog.present?

    @other_blogs = Blog.where("context = ? and id != '?'", @context, @blog.id).limit(9).order('created_at desc')

    respond_to do |format|
      format.html # show.haml relative to controller calling it
      format.xml  { render :xml => @blog }
    end
  end

  def edit
    @blog = Blog.find_by_title_for_url(params[:id]) || Blog.find_by_id(params[:id])

    respond_to do |format|
      format.html { render :template => "blogs/edit"}
      format.xml  { render :xml => @blog }
    end
  end

  def update
    @blog = Blog.find_by_title_for_url(params[:id]) || Blog.find_by_id(params[:id])

    # No, we don't pass the user in the form, but do update it with whomever is updating the blog entry.
    # Also, right now we don't update the context (meaning we move a 'trend' to a 'reason to sell', although
    # we very easily could)
    params[:blog].merge!(:user_id => current_user.id)

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to(construct_blog_path(@blog, :show), :notice => "#{@blog.title} was successfully updated.") }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
      blog = Blog.find_by_title_for_url(params[:id]) || Blog.find_by_id(params[:id])
      return_path = redirect_to(construct_blog_path(blog, :index))
      blog.destroy
  end

  def email_image
    begin
      @blog = Blog.find_by_title_for_url(params[:id]) || Blog.find_by_id(params[:id])
      mail = Mailer.email_image(params[:friends_email], params[:your_email], @blog)
      mail.deliver

      render :json => {:success => true}.to_json, :status => 200
    rescue => e
      log_exception(e)
      render :json => {:success => false}.to_json, :status => 500
    end
  end

  private

  # Which blog content is this. Possibly trends, reasons to sell or guides
  def setup_for_blog_context
    route = request.path_info.split('/').reject{|pi| pi.blank?}.first
    @context = Blog.translate_route_to_context(route)
    
    # Controls menu highlighting and arrow
    active_section(@context)
  end

  def log_exception(e)
    Rails.logger.fatal("#{e.class} (#{e.message}):\n" + clean_backtrace(e).join("\n    "));
  end

  def clean_backtrace(e)
    if backtrace = e.backtrace
      backtrace.map { |line| line.sub Rails.root.to_s, '' }
    end
  end

end
