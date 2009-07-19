class StatusesController < ApplicationController  
  include UserHelper
  
  before_filter :logged_user_filter 
  before_filter :admin_filter
  before_filter :user
  
  def update
    @user.switch_status(params[:id])
    flash[:notice] = "User status for #{@user.login} was changed"
    redirect_to :users        
  end
  
  private
  
  def user
    @user = User.find(params[:user_id])    
  end

end  