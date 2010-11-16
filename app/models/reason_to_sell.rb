class ReasonToSell < ActiveRecord::Base
  belongs_to :user
  
  # will_paginate : https://github.com/mislav/will_paginate
  cattr_reader :per_page
  @@per_page = 10
  
  # TODO -- younker [2010-11-09 10:51]
  # move photo styles, size and types into config
  has_attached_file :photo, :styles => { :small => '130x130>', :medium => "200x200>", :large => '300x300>' },
                    :url  => "/assets/reasons_to_sell/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/reasons_to_sell/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 500.kilobytes 
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validates_presence_of :user_id, :content, :title
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
