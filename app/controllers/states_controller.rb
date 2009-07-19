class StatesController < ApplicationController
  include TopicHelper
  
  before_filter :logged_user_filter
  before_filter :find_topic 
  before_filter :topic_editable
  before_filter :read_only_user
    
  def update
    @topic.switch_state
    flash[:notice] = "Topic has been #{@topic.opened? ? 'opened' : 'closed'}"
    redirect_to @topic      
  end

end  