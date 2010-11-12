module BreadcrumbHelper
  def crumbs_for_blog_object(obj)
    crumbs = [[:home, root_path]]

    page_crumb = ["page #{params[:page]}", nil] if params[:page].present?

    if obj.nil?
      crumbs.push([ctrl_name, path_for_controller(controller)])

    elsif obj.is_a?(Array)
      # if we got an array, then we are on an index page. Use the first object to get the crumb name (via their class).
      # However, if there is not first object, then we are on an index page view that does not have any results
      # (pagination url hacking most likely). In that case, look to see if there is a page crumb. If...
      #   1. there is a page crumb, then link the controller name to the controller's index
      #   2. there is NOT a page crumb, then leave the controller name linkless
      first_obj = obj.first
      name = first_obj.nil? ? controller.controller_name.to_s : first_obj.class.name.underscore.pluralize
      path = page_crumb.present? ? path_for_controller(controller) : nil
      crumbs.push([name, path])

    else
      crumbs.push([obj.class.name.underscore.pluralize, object_path(obj)])
    end

    crumbs.push(page_crumb) if page_crumb.present?

    crumbs
  end
  
  private 

  def path_for_controller(ctrl)
    name = controller.controller_name.to_s
    name.eql?('reasons_to_sell') ? send('reasons_path') : send("#{name}_path")
  end

end
