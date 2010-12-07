module BlogsHelper
  # Meta Title
  def title_for_context(pluralize=false)
    case @context
    when "trends"  then "Real Estate, Short Sale &amp; Foreclosure Trends"
    when "reasons" then "Sell My House or Property Fast"
    when "guides"  then "How to Sell your House &amp; Avoid Foreclosure"
    end
  end

  # Informal name
  def name_for_context(pluralize=false)
    pluralize ? @context.pluralize.titlelize : @context.singularize.titleize
  end

  def share_on_for_site(social_site, object=nil)
    case social_site.to_s.intern
    when :twitter
      ShareOn::Twitter.new(:resource => construct_url(object.title_for_url), :title => object.title)
    when :linkedin
      ShareOn::LinkedIn.new(:resource => construct_url(object.title_for_url), :title => object.title, :summary => object.teaser)
    when :facebook
      ShareOn::Facebook.new(:resource => construct_url(object.title_for_url))
    end
  end


  protected
  def construct_url(relative_path)
    "#{root_url}#{relative_path}"
  end

end
