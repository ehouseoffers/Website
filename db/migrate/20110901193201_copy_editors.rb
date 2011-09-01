class CopyEditors < ActiveRecord::Migration
  def self.up
    add_column :users, :copy_editor, :boolean, :default => false

    User.create!(:email => 'copy@ehouseoffers.com',
                :password => 'fake_password',
                :reset_password_token => nil,
                :remember_token => nil,
                :remember_created_at => nil,
                :sign_in_count => 0,
                :current_sign_in_at => nil,
                :last_sign_in_at => nil,
                :current_sign_in_ip => nil,
                :last_sign_in_ip => nil,
                :created_at => nil,
                :updated_at => nil,
                :first_name => "Copy",
                :last_name => "Editor",
                :admin => false,
                :copy_editor => true);
  end

  def self.down
    remove_column :users, :copy_editor
    User.find_by_email('copy@ehouseoffers.com').destroy
  end
end


