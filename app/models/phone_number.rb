# mysql> desc phone_numbers;
# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | user_id    | int(11)      | NO   |     | NULL    |                | 
# | number     | varchar(255) | NO   |     | NULL    |                | 
# | label      | varchar(255) | YES  |     | NULL    |                | 
# | primary    | tinyint(1)   | YES  |     | NULL    |                | 
# | created_at | datetime     | YES  |     | NULL    |                | 
# | updated_at | datetime     | YES  |     | NULL    |                | 
# +------------+--------------+------+-----+---------+----------------+
class PhoneNumber < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates :number, :presence => true, :phone_number_format => true

end
