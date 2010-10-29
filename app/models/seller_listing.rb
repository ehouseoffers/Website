class SellerListing < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  belongs_to :address
  belongs_to :phone_number

  validates_presence_of :user_id, :address_id, :phone_number_id

  # B/c I mass assign, help guard against hackers inserting values
  # http://railscasts.com/episodes/26-hackers-love-mass-assignment
  # http://railscasts.com/episodes/237-dynamic-attr-accessible
  attr_accessible :user_id, :phone_number_id, :address_id, :estimated_value, :asking_price, :loan_amount,
                  :currently_listed, :payments_are_current

  def initialize(args={})
    super(args)
    self.user = User.new unless self.user.present?
  end

  def asking_price=(string)
    write_attribute(:asking_price, sanitize_price(string))
  end
  def asking_price(raw=false)
    raw ? read_attribute(:asking_price) : number_to_currency(read_attribute(:asking_price))
  end

  def estimated_value=(string)
    write_attribute(:estimated_value, sanitize_price(string))
  end
  def estimated_value(raw=false)
    raw ? read_attribute(:estimated_value) : number_to_currency(read_attribute(:estimated_value))
  end

  def loan_amount=(string)
    write_attribute(:loan_amount, sanitize_price(string))
  end
  def loan_amount(raw=false)
    raw ? read_attribute(:loan_amount) : number_to_currency(read_attribute(:loan_amount))
  end

  # payments_are_current was set up as a boolean. However, there are 3 possible states. nil = n/a
  def payments_are_current=(value)
    write_attribute(:payments_are_current, (value.eql?('na') ? nil : value))
  end


  # Create a new seller_listing using the form params from the main page 'get a cash offer on your house today' form
  # younker [2010-10-25 13:36]
  #   I was unable to get accepts_nested_attributes_for working, so I build each one of these out by hand
  #   See the following in case you want to try and fix this:
  #     http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html
  #     http://media.railscasts.com/videos/196_nested_model_form_part_1.mov
  def self.wizard_step1(args)
    # User
    if user = User.find_by_email(args['user']['email'])
      user.update_attributes(:first_name => args['user']['first_name'],
                              :last_name  => args['user']['last_name'])
    else
      new_password = User.generate_new_password
      user = User.create(:password   => new_password, :confirmation_password => new_password,
                          :email      => args['user']['email'],
                          :first_name => args['user']['first_name'],
                          :last_name  => args['user']['last_name'])
    end

    # Address
    addr = user.addresses.find_by_address1_and_zip(args['address']['address1'], args['address']['zip'])
    addr = user.addresses.build(args['address']) if addr.nil?

    # Phone Number
    phone = user.phone_numbers.find_by_number(args['phone_number']['number'])
    phone = user.phone_numbers.build(args['phone_number']) if phone.nil?

    user.save!

    SellerListing.create!(:user_id => user.id, :address_id => addr, :phone_number_id => phone)
  end

  private
  
  def sanitize_price(string)
    string.gsub(/[^\.\d]+/,'')
  end
    
end
