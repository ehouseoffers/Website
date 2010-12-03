module SpotlightHelper

  def link_to_edit_collection_for(collection_target, context)
    cname = collection_target.to_s.downcase

    link_to("edit #{cname.pluralize.humanize.downcase}",
            send("edit_collection_#{cname.pluralize}_path", context.class.name.downcase, context.id),
            :class => :uso_modal,
            'data-resource'   => "edit_#{cname.singularize}_collection.css,edit_#{cname.singularize}_collection.js",
            'data-modal-args' => '{"minWidth":720}')
  end
end
