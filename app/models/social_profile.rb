# mysql> desc social_profiles;
# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | context    | varchar(255) | YES  |     | NULL    |                | 
# | context_id | varchar(255) | YES  |     | NULL    |                | 
# | website    | varchar(255) | YES  |     | NULL    |                | 
# | username   | varchar(255) | YES  |     | NULL    |                | 
# | url        | varchar(255) | YES  |     | NULL    |                | 
# | created_at | datetime     | YES  |     | NULL    |                | 
# | updated_at | datetime     | YES  |     | NULL    |                | 
# +------------+--------------+------+-----+---------+----------------+
class SocialProfile < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :context, :context_id, :website, :username, :url

  validates_presence_of :context, :context_id, :website, :url

  SOCIAL_SITES = [:twitter, :facebook, :linkedin, :youtube]

  def belongs_to
    ModelHelper.object_for(self.context_id, eval(self.context))
  end

end
