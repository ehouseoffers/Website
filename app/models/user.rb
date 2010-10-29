class User < ActiveRecord::Base
  has_many :seller_listings
  has_many :phone_numbers do 
    def primary  ; self.detect{|pn| pn.primary} ; end
    def primary? ; primary.present? ; end
  end

  has_many :addresses do
    def primary  ; self.detect{|pn| pn.primary} ; end
    def primary? ; primary.present? ; end
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # The rest should be taken care of by devise
  validates_presence_of :first_name

  after_save :phone_numbers do |foo|
    if self.phone_numbers.present? && !self.phone_numbers.primary?
      pn = self.phone_numbers.first
      pn.primary = true
      pn.label = 'Primary' if pn.label.blank?
      pn.save!
    end
  end
  
  after_save :addresses do |foo|
    if self.addresses.present? && !self.addresses.primary?
      addr = self.addresses.first
      addr.primary = true
      addr.label = 'Primary' if addr.label.blank?
      addr.save!
    end
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  def addresses?
    self.addresses.present?
  end

  def phone_numbers?
    self.phone_numbers.present?
  end

  def name
    if !self.first_name.blank?
      self.last_name.blank? ? self.first_name : "#{self.first_name} #{self.last_name}"
    elsif !self.last_name.blank?
      self.first_name.blank? ? self.last_name : "#{self.first_name} #{self.last_name}"    
    else
      self.email
    end
  end

  # For the seller listing form, we may or may not have a phone attached to this user. If so, we want that. If not,
  # we need a new phone_number object
  def phone_for_form
    self.phone_numbers? ? self.phone_numbers.primary : PhoneNumber.new
  end
  
  protected

  def self.generate_new_password(length=7)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(length) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
