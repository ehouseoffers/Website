class AddSalesforceIdToSellerListings < ActiveRecord::Migration
  def self.up
    add_column :seller_listings, :salesforce_lead_id, :string
    add_column :seller_listings, :salesforce_lead_owner_id, :string
  end

  def self.down
    remove_column :seller_listings, :salesforce_lead_id
    remove_column :seller_listings, :salesforce_lead_owner_id
  end
end


