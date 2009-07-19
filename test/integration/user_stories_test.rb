require File.dirname(__FILE__) + '/../test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "try to topics without login" do
  	get_via_redirect '/topics'
  	assert_template 'sessions/new'
  	assert_equal 'Please, log in, first', flash[:notice] 	
  end
  
  test 'default path' do
  	get_via_redirect '/'
  	assert_template 'sessions/new'
  	assert_equal 'Please, log in, first', flash[:notice] 	
  end

  test 'login with unexistent user' do
  	get 'session/new'
  	assert_template 'sessions/new'
	post session_path
  	assert_template 'sessions/new'
  	assert_equal 'Incorrect login/password', flash[:notice]
  	
	post session_path, {:login =>'unexistent', :password => 'bad'}
  	assert_template 'sessions/new'
  	assert_equal 'Incorrect login/password', flash[:notice] 		
  end
  
  test 'success login' do
  	user = users(:admin)
	post_via_redirect session_path, {:login =>user.login, :password => 'test'}
  	assert_template 'topics/index'
  	assert_equal 'Logged in successfully', flash[:notice] 		
  end
  

  	
end
