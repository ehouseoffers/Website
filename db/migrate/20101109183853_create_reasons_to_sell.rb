class CreateReasonsToSell < ActiveRecord::Migration
  def self.up
    create_table :reasons_to_sell do |t|
      t.integer :user_id
      t.string :title
      t.text   :content
      t.string :url_friendly_title
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :reasons_to_sell
  end
end

