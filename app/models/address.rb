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
