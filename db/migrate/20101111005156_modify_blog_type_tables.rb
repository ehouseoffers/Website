class ModifyBlogTypeTables < ActiveRecord::Migration
  def self.up
    # Guides
    rename_column :guides, :url_friendly_title, :title_for_url
    add_column :guides, :teaser, :string

    # Reasons to Sell
    rename_column :reasons_to_sell, :url_friendly_title, :title_for_url
    add_column :reasons_to_sell, :teaser, :string
  end

  def self.down
    rename_column :guides, :title_for_url, :url_friendly_title
    remove_column :guides, :teaser
    rename_column :reasons_to_sell, :title_for_url, :url_friendly_title
    remove_column :reasons_to_sell, :teaser
  end
end
