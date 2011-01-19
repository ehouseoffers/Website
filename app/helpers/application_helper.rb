module ApplicationHelper

  # Add some data inside the HTML header; must have corresponding
  # content_for?(:foo) ? yield(:foo) : 'default' inside layout.
  # Defaults -- :title, :keywords, :description
  # Example
  #   header(:title, "Administration Functions")
  def header(name, *content)
    case name
    when :title
      content_for :header_title do "#{content.to_s} : eHouseOffers.com" end
      content_for :banner_title do "#{content.to_s}" end
    else content_for name do content.to_s end
    end
  end

  # Page title inside the body at the top of the main content section
  # Example:
  #   page_title("Administration Functions")
  def page_title(page_title)
    unless page_title.blank?
      content_for :page_title do
        content_tag(:h1, page_title, :id => 'page_title')
      end
    end
  end

  # younker [2010-11-15 14:46] -- JS/CSS Not Loading?!?
  # If you are looking here because extra_js and extra_css are NOT loading the files you want, check first to see
  # if your controller is using InheritedResources::Base. If so, that is the problem. See interviews_controller
  # some more details.

  def extra_js(*targets)
    @js_targets ||= []

    # Rails.logger.info("+ Extra JS: Request to add extra js: #{targets.inspect}")
    targets.each do |filename|
      if @js_targets.include?(filename)
        # Rails.logger.info("- Extra JS: @js_targets already has entry for #{filename}. Skipping")
      else
        # Rails.logger.info("- Extra JS: #{filename} not found in @js_targets")
        @js_targets.push(filename)

        # allow 'http://path' or '//path'
        path = filename.match(/^(http(s)?:\/)?\//).present? ? filename : "/javascripts/#{filename}.js"
        content_for :extra_js do
          js = "<script src='#{path}' type='text/javascript'></script>\n"
          # Rails.logger.info("- Extra JS: Adding: #{js}")
          js
        end
      end
    end
    # Rails.logger.info("- Extra JS: Current @js_targets: #{@js_targets.inspect}")
  end

  def extra_css(*targets)
    @css_targets ||= []

    # Rails.logger.info("+ Extra CSS: Request to add extra css: #{targets.inspect}")
    targets.each do |filename|
      if @css_targets.include?(filename)
        # Rails.logger.info("- Extra CSS: @css_targets already has entry for #{filename}. Skipping")
      else
        # Rails.logger.info("- Extra CSS: #{filename} not found in @css_targets")
        @css_targets.push(filename)
        content_for :extra_css do
          css = "<link href='/stylesheets/#{filename}.css' media='screen' rel='stylesheet' type='text/css' />\n"
          # Rails.logger.info("- Extra CSS: Adding: #{css}")
          css
        end
      end
    end
    # Rails.logger.info("- Extra CSS: Current @css_targets: #{@css_targets.inspect}")
  end


  # http://media.railscasts.com/videos/208_erb_blocks_in_rails_3.mov
  def admin_area(&block)
    content_tag(:div, :class => "admin", &block) if user_signed_in? && current_user.admin?
  end

  def admin?
    user_signed_in? && current_user.admin?
  end
  
  def standard_oops_message(type='data')
    "We're sorry, but there was a problem removing this #{type}. Please reload the page and try again. If the problem persists, please email customer-service@ehouseoffers.com."
  end


  # For all it's clever little things, Rails does not have a way to
  # get an absolute image path for image_tag which, for emails, is a
  # necessity.
  # Params
  #   image   : path (from the /images directory) to the image
  #   options : any options which image_tag will take. See:
  #             http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#M001690
  def image_tag_url(image, options={})
    image_tag "#{root_url}images/#{image.gsub(/^\//,'')}", options
  end
  
  def social_link(site,target,args={})
    path = case site.to_s.intern
    when :linkedin then 'http://www.linkedin.com/groups?mostPopular=&gid=3186741'
    when :twitter  then 'http://twitter.com/ehouseoffers'
    when :facebook then 'http://www.facebook.com/pages/eHouseOfferscom/129602593768138'
    when :youtube  then 'http://www.youtube.com/user/ehouseoffers'
    end

    link_to target, path, args.merge(:target => 'new')
  end

  def construct_blog_path(obj, action='index', context=nil, full_path=false)
    if obj.present?
      raise "Invalid Context -- #{obj.context}" unless obj.valid_context?
      context = obj.context
    elsif context.present?
      raise "Invalid Context -- #{context}" unless Blog::VALID_CONTEXTS.include?(context.to_s)
    else
      raise "Invalid"
    end
    
    rel_path = case action.to_s.intern
    when :index           then "/#{Blog.translate_context_to_route(obj.context)}"
    when :create          then send("#{context.pluralize}_path")
    when :new, :edit      then send("#{action.to_s}_#{context.singularize}_path")
    when :show, :update, :delete then send("#{context.singularize}_path", obj.respond_to?(:title_for_url) ? obj.title_for_url : obj.id)
    end
  
    full_path ? "#{root_url}#{rel_path.gsub(/^\//,'')}" : rel_path
  end

  def url_for_ssl(url_cmd, id=nil)
    url = id.nil? ? send(url_cmd) : send(url_cmd.to_s, id)
    url.gsub!(/3000/,'3001') if Rails.env.eql?('development')
    url
  end
end
