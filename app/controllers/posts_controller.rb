class PostsController < ApplicationController
  before_filter :logged_user_filter  
  before_filter :find_topic
  before_filter :find_post, :except => [:index, :new, :create]
  before_filter :read_only_user  
  
  def new
    unless @topic.opened?
      flash[:notice] = "You cannot add post to this topic"
      redirect_to @topic
    end      
    @post = Post.new
  end
  	
  def edit
    unless current_user.editable_obj?(@post) && @topic.opened?
      flash[:notice] = "You cannot edit this post"
      redirect_to @topic
    end    
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @topic.posts << @post
      flash[:notice] = 'Post was successfully created.'
      redirect_to(@topic)
    else
      render :action => "new"
    end
  end
  
  def update  
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to(@topic)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @post.destroy
    flash[:notice] = "Post was deleted"
    redirect_to(@topic)
  end

  private
  
  def find_topic
    @topic = Topic.find(params[:topic_id])
    rescue
      flash[:notice] = "Please, select topic from list bellow"
      redirect_to topics_path        
  end
  
  def find_post
    @post = @topic.posts.find(params[:id])
    rescue
      flash[:notice] = "Please, select post from list bellow"
      redirect_to @topic        
  end
  
end
