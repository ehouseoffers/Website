# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | context    | varchar(255) | YES  |     | NULL    |                | 
# | context_id | int(11)      | YES  |     | NULL    |                | 
# | content    | text         | YES  |     | NULL    |                | 
# | created_at | datetime     | YES  |     | NULL    |                | 
# | updated_at | datetime     | YES  |     | NULL    |                | 
# +------------+--------------+------+-----+---------+----------------+
class BulletPoint < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :context, :context_id, :content

  validates_presence_of :context, :context_id, :content

  def belongs_to
    ModelHelper.object_for(self.context_id, eval(self.context))
  end
end
