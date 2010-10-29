class SellerListing < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  belongs_to :phone_number

  validates_presence_of :user_id, :address_id, :phone_number_id

  def initialize(args={})
    super(args)
    self.user = User.new unless self.user.present?
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
    
end
