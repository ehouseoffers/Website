module HomeHelper
  def what_we_do_modal(target)
    link_to target, what_we_do_path(), :class => 'uso_modal', 'data-resource' => 'what_we_do.css'
  end
end
