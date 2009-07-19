require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  
  test 'presence content' do
    post = Post.new
    assert !post.valid?
    assert_equal DEFAULT_ERRORS[:blank], post.errors.on(:content)
  end

  test 'save ok' do
    post = Post.new(:content => 'test')
    assert post.valid?
    assert post.save
    assert_equal post, Post.find_by_id(post.id)
  end
  
end
