class PhoneNumber < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates :number, :presence => true, :phone_number_format => true

end
