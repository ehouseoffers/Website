class CreateUploadedPhotos < ActiveRecord::Migration
  def self.up
    create_table :uploaded_photos do |t|
      t.integer :id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_photos
  end
end
