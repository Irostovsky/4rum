class PhotosManagementsController < ApplicationController

  def show
    photo = Photo.find_by_id(params[:id])
    p photo.content.nil?
    send_data( photo.content, 
               :filename => photo.filename,
               :type => photo.content_type,
               :dispsition => 'inline')
  end
  
end
