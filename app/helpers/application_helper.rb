module ApplicationHelper

  # Add some data inside the HTML header; must have corresponding
  # content_for?(:foo) ? yield(:foo) : 'default' inside layout.
  # Defaults -- :title, :keywords, :description
  # Example
  #   header(:title, "Administration Functions")
  def header(name, *content)
    case name
    when :title  then content_for :header_title do "#{content.to_s} : eHouseOffers.com" end
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

  def extra_js(*targets)
    targets.each do |f|
      content_for :extra_js do "<script src='/javascripts/#{f}.js' type='text/javascript'></script>\n" end
    end
  end

  def extra_css(*targets)
    targets.each do |f|
      content_for :extra_css do "<link href='/stylesheets/#{f}.css' media='screen' rel='stylesheet' type='text/css' />\n" end
    end
  end

end