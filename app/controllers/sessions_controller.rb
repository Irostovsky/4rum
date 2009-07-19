class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  def new
  end
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Incorrect login/password"      
      render :action => 'new'      
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:new_session)
  end
  
end
