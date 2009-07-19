require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < ActiveSupport::TestCase
  fixtures :users, :topics, :posts	
  test 'validate presence' do
    topic = Topic.new
    assert !topic.valid?
    assert_equal DEFAULT_ERRORS[:blank], topic.errors.on(:title)
    assert_equal DEFAULT_ERRORS[:blank], topic.errors.on(:content)
  end
  
  test 'save ok' do
    topic = Topic.new(:title => 'test', :content => 'test')
    assert topic.valid?
    assert topic.save
    assert_equal topic, Topic.find_by_id(topic.id)
  end
  
  test 'switch state' do
    topic = topics(:opened)
    assert topic.opened?
    topic.switch_state
    topic = Topic.find(topic)
    assert !topic.opened?
    topic.switch_state
    topic = Topic.find(topic)
    assert topic.opened?  
  end
  
  test 'paginate topics' do
  	assert Topic.count > 2
  	topics = Topic.per_page({},2)
  	assert_equal 2, topics.size  
  	assert_equal topics(:opened), topics[0]	
  end	

  test 'paginate topics and search' do
  	assert Topic.count > 2
  	topics = Topic.per_page({:search => 'Opene'},2)
  	assert_equal 1, topics.size  
  	assert_equal topics(:opened), topics[0]	
  end	
  	
  	
  test 'paginate topic posts' do
  	topic = Topic.find_by_id(1)
  	assert topic.posts.size > 2 
  	posts_1 = topic.posts.per_page({},2)
  	assert_equal 2, posts_1.size 
  end	
  
  test 'delete posts when topic deleted' do
  	topic = Topic.find_by_id(1)
  	assert topic.posts.size > 2
  	assert topic.destroy
  	assert_nil Topic.find_by_id(1) 
    assert Post.count(:conditions => ['topic_id = 1']).zero?
  end	
  
end
