class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.integer :user_id, :null => false
      t.string :number, :null => false
      t.string :label
      t.boolean :primary

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
