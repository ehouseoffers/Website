# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create!(:email => 'admin@ehouseoffers.com', :password => 'fake_password', :first_name => "eHouseOffers", :last_name => "Admin", :admin => true, :copy_editor => true);

User.create!(:email => 'jason@ynkr.org', :password => 'asdf', :first_name => "jason", :last_name => "ynkr", :admin => false, :copy_editor => false);
