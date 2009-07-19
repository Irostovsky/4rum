class UsersController < ApplicationController
  include AuthenticatedSystem, UserHelper
  
  before_filter :logged_user_filter, :only => [:index]  
  before_filter :admin_filter, :only => [:index]

  def new
  end
  
  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def index
    @users = User.simple_users    
  end  

end
