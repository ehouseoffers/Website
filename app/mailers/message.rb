# Tableless model to allow us to construct messages to mail and run basic validations on them.
# For more on tableless models, see http://media.railscasts.com/videos/219_active_model.mov
class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  VALID_FIELDS = %w[name email subject body]
  attr_accessor :name, :email, :subject, :body
  
  # For more on validations, see http://lindsaar.net/2010/1/31/validates_rails_3_awesome_is_true
  validates_presence_of :name, :subject
  validates :email, :presence => true, :email_format => true
  validates :body, :presence => true, :length => {:maximum => 1000}
  
  def initialize(params={})
    VALID_FIELDS.each do |field|
      if params.has_key?(field.intern)
        p "has key #{field} -- #{params[field.intern]}"
        send("#{field}=", params[field.intern])
      end
    end
  end

  def from
    "#{self.name} <#{self.email}>"
  end

  def persisted?
    false
  end
end

