class UploadedPhoto < ActiveRecord::Base

  has_attached_file :photo,
                    :styles => {:small => '130x130>'},
                    :url  => "/assets/uploaded_files/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/uploaded_files/:style/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => APP_CONFIG['photo']['max_size']
  validates_attachment_content_type :photo, :content_type => APP_CONFIG['photo']['types']
  
end
