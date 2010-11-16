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

end
