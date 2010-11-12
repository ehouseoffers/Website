class ChangeSellerListingStep2 < ActiveRecord::Migration
  def self.up
    remove_column :seller_listings, :currently_listed
    remove_column :seller_listings, :payments_are_current
    add_column :seller_listings, :selling_reason, :text
    add_column :seller_listings, :time_frame, :integer
  end

  def self.down
    add_column :seller_listings, :currently_listed, :boolean
    add_column :seller_listings, :payments_are_current, :boolean
    remove_column :seller_listings, :selling_reason
    remove_column :seller_listings, :time_frame
  end
end
