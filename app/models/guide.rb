class Guide < ActiveRecord::Base
  belongs_to :user
  
  # models/product.rb
  has_attached_file :photo, :styles => { :small => '130x130>', :medium => "200x200>" },
                    :url  => "/assets/guides/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/guides/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  before_save :title do
    if (self.new_record? && self.url_friendly_title.blank?) || self.url_friendly_title.blank?
      write_attribute(:url_friendly_title, self.title.make_url_friendly)
    end
  end

  # Do NOT update unless it is a new record. Once it is saved, we do not modify so that if any search engines have
  # indexed this guide using the url friendly title string, we do not hose ourself by changing the path to it
  def url_friendly_title=(string)
    if self.new_record?
      write_attribute(:url_friendly_title, string)
    end
  end
end
