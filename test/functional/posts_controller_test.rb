require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :users, :topics, :posts

  test 'new not logged user' do
    get :new, {:topic_id => topics(:opened)}
    assert_redirected_to :new_session  	
  end	

  test 'new topic not opened' do
  	closed_topic = topics(:closed)
    get :new, {:topic_id => closed_topic}, :user_id => users(:admin)
    assert_redirected_to closed_topic  	
  end	
  	  
  test "should get index" do
    begin
      get :index, {:topic_id => topics(:opened)}, :user_id => users(:admin)
      assert false
    rescue  
      assert true
    end
  end

  test "should get new" do
    get :new, {:topic_id => topics(:opened)}, :user_id => users(:admin)
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, {:post => {:content => 'hello' }, :topic_id => topics(:opened)}, :user_id => users(:admin)
    end

   assert_redirected_to topics(:opened)
  end

  test "should get edit" do
  	topic = topics(:opened)
  	post = topic.posts[0]
    get :edit, {:id => post, :topic_id => topic}, :user_id => users(:admin)
    assert_response :success
  end

  test "should update post" do
  	topic = topics(:opened)
  	post = topic.posts[0]
    put :update, {:id => post, :post => { :content => 'new'}, :topic_id => topic}, :user_id => users(:admin)
    assert_redirected_to topic
  end

  test "should destroy post" do
   	topic = topics(:opened)
  	post = topic.posts[0]
  	assert_difference('Post.count', -1) do
      delete :destroy, {:id => post, :topic_id => topic}, :user_id => users(:admin)
    end
    assert_redirected_to topic
  end
end
