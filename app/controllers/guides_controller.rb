class GuidesController < BlogsController

  # A guide is basically another type of blog. Everything in /app/views/blogs displays a blog in a certain manner; see
  # the trends or reasons to sell sections of the site for that style. The guides blog entries have a different UI
  # presentation to them, so the question became how do we reuse all the blog controller/model stuff without any
  # duplication? Well, my answer was to create this controller and have it inherit from BlogsController. Then, in the
  # blogs_controller, in each actions respond_to, we use a full render :template path, i.e. /blogs/index, when
  # we want to show exactly the same UI presentation as all the other blogs (edit, new) and a relative render :template
  # path when we want to render the template in the ap/views directory of the controller being used (index, show)
  def index  ; super ; end
  def show   ; super ; end
  def new    ; super ; end
  def edit   ; super ; end
  def create ; super ; end
  def destroy; super ; end
  def update ; super ; end
end
