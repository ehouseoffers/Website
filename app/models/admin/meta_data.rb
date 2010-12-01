# mysql> desc admin_meta_datum;
# +---------------+--------------+------+-----+---------+----------------+
# | Field         | Type         | Null | Key | Default | Extra          |
# +---------------+--------------+------+-----+---------+----------------+
# | id            | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | relative_path | varchar(255) | YES  |     | NULL    |                | 
# | title         | text         | YES  |     | NULL    |                | 
# | description   | text         | YES  |     | NULL    |                | 
# | keywords      | text         | YES  |     | NULL    |                | 
# | created_at    | datetime     | YES  |     | NULL    |                | 
# | updated_at    | datetime     | YES  |     | NULL    |                | 
# +---------------+--------------+------+-----+---------+----------------+
class Admin::MetaData < ActiveRecord::Base
  
  validate :relative_path, :unique => true do
    match_data = self.relative_path.match(/^https?:\/\/[^\/]+(.*)$/)
    if match_data.present?
      self.relative_path = match_data.captures.first
    end
    # remove any double slashes
    self.relative_path.gsub!(/\/+/,'/')    

    # make sure it starts with a slash
    self.relative_path = self.relative_path.index('/')==0 ? self.relative_path : "/#{self.relative_path}"

    # Make sure it is a valid route for this site
    begin
      Rails.application.routes.recognize_path(self.relative_path)
    rescue
      errors.add(:relative_path, "The relative path #{self.relative_path} does not exist")
    end
  end

end
