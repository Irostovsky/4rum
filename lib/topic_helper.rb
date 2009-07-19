module TopicHelper
  
	private

  def find_topic
    @topic = Topic.find(params[:id])
    rescue
      flash[:notice] = "Please, select topic from list bellow"
      redirect_to topics_path        
  end

  def topic_editable
    unless current_user.editable_obj?(@topic)
      flash[:notice] = "You cannot edit this topic"
      redirect_to @topic
    end      
  end
      	
end	