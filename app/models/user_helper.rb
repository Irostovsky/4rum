module UserHelper
  private
  
  def admin_filter
    unless current_user.admin?
      flash[:notice] = 'You should have admin proveleges to to this'
      redirect_to(:topics)  
      end      
  end  
  
end  