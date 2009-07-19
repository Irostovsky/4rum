class ApplicationController < ActionController::Base
  include AuthenticatedSystem  
  
  helper :all 
  
  protect_from_forgery 
   
  private

  def logged_user_filter
    if !logged_in?
      store_location          
      flash[:notice] = 'Please, log in, first'            
      redirect_to(:new_session)
    end   
  end    

  def read_only_user
    if current_user.read_only?
      flash[:notice] = "You cannot add/edit topics and posts"
      redirect_to :topics
    end      
  end  

       
end
  