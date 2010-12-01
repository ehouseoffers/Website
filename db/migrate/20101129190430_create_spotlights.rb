class CreateSpotlights < ActiveRecord::Migration
  def self.up
    create_table :spotlights do |t|
      t.integer :id
      t.string :title
      t.string :title_for_url
      t.text :teaser
      t.string :about_title
      t.string :interview_title
      t.string :interview_subtitle
      t.string :social_media_title
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :spotlights
  end
end

