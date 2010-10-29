class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :user_id, :null => false
      t.string :address1, :null => false
      t.string :address2
      t.string :city
      t.string :state
      t.integer :zip, :null => false
      t.string :label
      t.boolean :primary, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end

