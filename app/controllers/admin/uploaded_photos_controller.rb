class Admin::UploadedPhotosController < InheritedResources::Base
  before_filter :redirect_unless_admin
  layout :layout

  # we upload via ckeditor which left to it's own devices will throw ActionController::InvalidAuthenticityToken
  protect_from_forgery :except => [:create]

  def create
    begin
      photo = UploadedPhoto.new(:photo => params[:upload])
      photo.save!
      render :text => photo.photo.url and return
    rescue => e
      render :text => "Error! #{photo.errors.full_messages.join(", ")}"
    end
  end  
end
