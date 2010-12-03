class RenameSocialMedia < ActiveRecord::Migration
  def self.up
    rename_column :spotlights, :social_media_title, :social_profile_title
  end

  def self.down
    rename_column :spotlights, :social_profile_title, :social_media_title
  end
end
