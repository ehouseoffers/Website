# mysql> desc spotlights;
# +--------------------+--------------+------+-----+---------+----------------+
# | Field              | Type         | Null | Key | Default | Extra          |
# +--------------------+--------------+------+-----+---------+----------------+
# | id                 | int(11)      | NO   | PRI | NULL    | auto_increment | 
# | title              | varchar(255) | YES  |     | NULL    |                | 
# | title_for_url      | varchar(255) | YES  |     | NULL    |                | 
# | teaser             | varchar(255) | YES  |     | NULL    |                | 
# | about_title        | varchar(255) | YES  |     | NULL    |                | 
# | interview_title    | varchar(255) | YES  |     | NULL    |                | 
# | interview_subtitle | varchar(255) | YES  |     | NULL    |                | 
# | social_media_title | varchar(255) | YES  |     | NULL    |                | 
# | photo_file_name    | varchar(255) | YES  |     | NULL    |                | 
# | photo_content_type | varchar(255) | YES  |     | NULL    |                | 
# | photo_file_size    | int(11)      | YES  |     | NULL    |                | 
# | photo_updated_at   | datetime     | YES  |     | NULL    |                | 
# | created_at         | datetime     | YES  |     | NULL    |                | 
# | updated_at         | datetime     | YES  |     | NULL    |                | 
# +--------------------+--------------+------+-----+---------+----------------+
class Spotlight < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :title, :title_for_url, :teaser, :about_title, :interview_title, :interview_subtitle,
                  :social_media_title, :photo

  has_many :qas,             :foreign_key => "context_id", :conditions => "context='Spotlight'", :order => 'created_at asc'
  has_many :bullet_points,   :foreign_key => "context_id", :conditions => "context='Spotlight'", :order => 'created_at asc'
  has_many :social_profiles, :foreign_key => "context_id", :conditions => "context='Spotlight'", :order => 'created_at asc'

  has_attached_file :photo,
                    :styles => APP_CONFIG['photo']['styles'],
                    :url    => "/assets/spotlights/:id/:style/:basename.:extension",
                    :path   => ":rails_root/public/assets/spotlights/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => APP_CONFIG['photo']['max_size']
  validates_attachment_content_type :photo, :content_type => APP_CONFIG['photo']['types']

  validates_presence_of :title, :teaser

  # TODO -- younker [2010-11-29 11:57]
  # Take all the title_for_url stuff (validates :title_for_url, before_validation :title and def title_for_url writter)
  # and make this into a class. There is dupication between this model and the blog model
  validates :title_for_url, :uniqueness => true

  before_validation :title do
    if (self.new_record? && self.title_for_url.blank?) || self.title_for_url.blank?
      write_attribute(:title_for_url, self.title.make_url_friendly)
    end
  end

  # Do NOT update unless it is a new record. Once it is saved, we do not modify so that if any search engines have
  # indexed this guide using the url friendly title string, we do not hose ourself by changing the path to it
  def title_for_url=(string)
    if self.new_record?
      write_attribute(:title_for_url, string)
    end
  end


end
