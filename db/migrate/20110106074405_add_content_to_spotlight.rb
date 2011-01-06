class AddContentToSpotlight < ActiveRecord::Migration
  def self.up
    add_column :spotlights, :content, :text
  end

  def self.down
    remove_column :spotlights, :content
  end
end
