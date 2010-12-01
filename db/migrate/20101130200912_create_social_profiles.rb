class CreateSocialProfiles < ActiveRecord::Migration
  def self.up
    create_table :social_profiles do |t|
      t.integer :id
      t.string :context
      t.string :context_id
      t.string :website
      t.string :username
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :social_profiles
  end
end
