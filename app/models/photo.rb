class Photo < ActiveRecord::Base
  
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :size => 0.megabyte..2.megabytes,
                 :resize_to => '150',
                 :path_prefix => 'public/files',
                 :processor => 'MiniMagick'            
                 
  validates_as_attachment
  
  belongs_to :user
  
  def self.select(to_select_id, logged_user)
    user_photos = logged_user.photos
    user_photos.update_all('selected = false')
    photo = user_photos.find_by_id(to_select_id)
    photo.update_attributes(:selected => true) if photo
  end
  	
end
