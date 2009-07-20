class PhotosController < ApplicationController

  before_filter :logged_user_filter

  def index
    @photos = Photo.all
  end

  def show
    Photo.select(params[:id], current_user)   
    redirect_to user_photos_path(current_user)
  end
  
  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo])
    #@photo.user = current_user
    if current_user.photos << @photo #@photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to user_photos_path(current_user)     
    else
      render :action => :new
    end
  end

end
