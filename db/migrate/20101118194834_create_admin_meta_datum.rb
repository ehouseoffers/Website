class CreateAdminMetaDatum < ActiveRecord::Migration
  def self.up
    create_table :admin_meta_datum do |t|
      t.integer :id
      t.string :relative_path
      t.text :title
      t.text :description
      t.text :keywords
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_meta_datum
  end
end
