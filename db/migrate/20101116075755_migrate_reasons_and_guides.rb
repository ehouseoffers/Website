# younker [2010-11-19 14:51]
# The ReasonToSell and Guide models are gone, so these bomb every time
class MigrateReasonsAndGuides < ActiveRecord::Migration
  # include FileUtils

  def self.up
    # ReasonToSell.all.each do |r|
    #   b = Blog.new(:context => 'reasons', :user_id => r.user_id, :title => r.title,
    #                :title_for_url => r.title_for_url, :photo_file_name => r.photo_file_name, :content => r.content,
    #                :photo_content_type => r.photo_content_type, :photo_file_size => r.photo_file_size,
    #                :photo_updated_at => r.photo_updated_at, :created_at => r.created_at, :teaser => r.teaser)
    #   b.save!
    # 
    #   src  = "#{Rails.root}/public/assets/reasons_to_sell/#{r.id}"
    #   dest = "#{Rails.root}/public/assets/blog/#{b.id}"
    #   FileUtils.cp_r src, dest
    # 
    #   p "Reason: [#{b.id}] #{b.title}"
    # end
    # 
    # Guide.all.each do |g|
    #   b = Blog.new(:context => 'guides', :user_id => g.user_id, :title => g.title,
    #                :title_for_url => g.title_for_url, :photo_file_name => g.photo_file_name, :content => g.content,
    #                :photo_content_type => g.photo_content_type, :photo_file_size => g.photo_file_size,
    #                :photo_updated_at => g.photo_updated_at, :created_at => g.created_at, :teaser => g.teaser)
    #   b.save!
    # 
    #   src  = "#{Rails.root}/public/assets/guides/#{g.id}"
    #   dest = "#{Rails.root}/public/assets/blog/#{b.id}"
    #   FileUtils.cp_r src, dest
    # 
    #   p "Guide: [#{b.id}] #{b.title}"
    # end
  end

  def self.down
    # Blog.where('context = ?', 'reasons').each { |b| b.destroy }
    # Blog.where('context = ?', 'guides').each { |b| b.destroy }
  end
end
