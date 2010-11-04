class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides do |t|
      t.integer :user_id
      t.string :title
      t.string :url_friendly_title
      t.text   :content
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :guides
  end
end

