class CreateSellerListings < ActiveRecord::Migration
  def self.up
    create_table :seller_listings do |t|
      t.integer :user_id, :null => false
      t.integer :address_id, :null => false
      t.integer :phone_number_id, :null => false
      t.column  :estimated_value, :decimal, :precision => 12, :scale => 2
      t.column  :asking_price, :decimal, :precision => 12, :scale => 2
      t.column  :loan_amount, :decimal, :precision => 12, :scale => 2
      t.boolean :currently_listed
      t.boolean :payments_are_current

      t.timestamps
    end
  end

  def self.down
    drop_table :seller_listings
  end
end


