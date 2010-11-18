# http://thewebfellas.com/blog/2010/8/22/revisited-roll-your-own-pagination-links-with-will_paginate-and-rails-3
# I had to do this for the blog sections....<explain more here>
class BlogPaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

  def link(text, target, attributes = {})
    if target.is_a? Fixnum
      attributes[:rel] = rel_value(target)
      target = url(target)

      # younker [2010-11-17 22:17]
      # We have blogs of many contexts. However, will_paginate's url(target) will create a /blogs?page=2 link
      # regardless of the context. This is my way of hacking it to get us the proper route
      context = @collection.first.context
      context_route = Blog.translate_context_to_route(context)
      target.gsub!('blogs', context_route)
    end
    attributes[:href] = target
    tag(:a, text, attributes)
  end

end