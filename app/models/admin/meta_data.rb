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
