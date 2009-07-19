class TopicsController < ApplicationController
  include TopicHelper
    
  before_filter :logged_user_filter
  before_filter :find_topic, :only => [:show, :edit, :update, :destroy] 
  before_filter :topic_editable, :only => [:edit, :update, :destroy]
  before_filter :read_only_user, :except => [:show, :index]
   
  def index
  @topics = Topic.per_page params    
  end
  
  def show
    @posts = @topic.posts.per_page params
  end
  
  def new
    @topic = Topic.new
  end
  
  def edit
  end
  
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user
    if @topic.save
      flash[:notice] = 'Topic was successfully created.'
      redirect_to(@topic)
    else
      render :action => "new" 
    end
  end
  
  def update
    if @topic.update_attributes(params[:topic])
      flash[:notice] = 'Topic was successfully updated.'
      redirect_to(@topic)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @topic.destroy
    flash[:notice] = "Topic was deleted"
    redirect_to(topics_url)
  end

end
