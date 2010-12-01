class CreateBulletPoints < ActiveRecord::Migration
  def self.up
    create_table :bullet_points do |t|
      t.string :context
      t.integer :context_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :bullet_points
  end
end
