# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | user_id    | int(11)      | NO   |     | NULL    |                | 
# | address1   | varchar(255) | NO   |     | NULL    |                | 
# | address2   | varchar(255) | YES  |     | NULL    |                | 
# | city       | varchar(255) | YES  |     | NULL    |                | 
# | state      | varchar(255) | YES  |     | NULL    |                | 
# | zip        | int(11)      | NO   |     | NULL    |                | 
# | label      | varchar(255) | YES  |     | NULL    |                | 
# | primary    | tinyint(1)   | YES  |     | 0       |                | 
# | created_at | datetime     | YES  |     | NULL    |                | 
# | updated_at | datetime     | YES  |     | NULL    |                | 
# +------------+--------------+------+-----+---------+----------------+
class Address < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :zip

  validate :address1, :presence => true do |foo|
    # The db is set up to require address1, so move address2 to address1 if possible, otherwise, error out
    if self.address1.blank?
      if self.address2.blank?
        errors.add(:address1, 'cannot be blank')
      else
        self.address1 = self.address2
        self.address2 = nil
      end
    end
  end

end
