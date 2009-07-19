require File.dirname(__FILE__) + '/../test_helper'

class SearchTest < ActiveSupport::TestCase
	
  fixtures :users, :topics, :posts
  
=begin
  test "test" do
    search = Search.new
    p search.conditions('topic')
  end
=end
   
  test "search default" do
    search = Search.new
    result = search.result
    assert_equal Topic.count + Post.count, result.size
  end

  
  test "search title full" do
    search = Search.new(:keywords => 'string', :place => 'title')
    result = search.result
    assert_equal 2, result.size
    assert_equal topics(:one, :two), result
  end
 
  test "search content full" do
    search = Search.new(:keywords => 'text', :place => 'content')
    result = search.result
    assert_equal 2, result.size
    assert_equal topics(:one, :two), result
  end

  test "search post full" do
    search = Search.new(:keywords => 'search1', :place => 'post')
    result = search.result
    assert_equal 1, result.size
    assert_equal [posts(:search1)], result
  end  
 
  test "search all full" do
    search = Search.new(:keywords => 'text')
    result = search.result
    assert_equal 6, result.size
    assert topics(:one, :two, :topic5) + posts(:one, :two, :search1) == result
  end

  test "search title words" do
    search = Search.new(:keywords => 'text string', :occurrence => 'words', :place => 'title')
    result = search.result
    assert_equal 1, result.size
    assert [topics(:one)] == result
  end

  test "search content words" do
    search = Search.new(:keywords => 'My xt', :occurrence => 'words', :place => 'content')
    result = search.result
    assert_equal 2, result.size
    assert topics(:one, :two) == result
  end

  test "search post words" do
    search = Search.new(:keywords => 'xt', :occurrence => 'words', :place => 'post')
    result = search.result
    assert_equal 3, result.size
    assert posts(:one, :two, :search1) == result
  end

  test "search all by words" do
    search = Search.new(:keywords => 'te xt', :occurrence => 'words')
    result = search.result
    assert_equal 6, result.size
    assert topics(:one, :two, :topic5) + posts(:one, :two, :search1) == result
  end
 
  test "search date_from title" do
    search = Search.new( :date_from => '2009-06-27', :place => 'title')
    result = search.result
    assert_equal 1, result.size
    assert [topics(:topic5)] == result
  end
  
  test "search date_from post" do
    search = Search.new( :date_from => '2009-06-30', :place => 'post')
    result = search.result
    assert_equal 1, result.size
    assert [posts(:search1)] == result
  end

  test "search date_from all" do
    search = Search.new( :date_from => '2009-06-27')
    result = search.result
    assert_equal 4, result.size
    assert [topics(:topic5)] + posts(:three, :for_opened_topic, :search1) == result
  end

  test "search date_from all words" do
    search = Search.new( :date_from => '2009-06-27', :keywords => 'Text some')
    result = search.result
    assert_equal 1, result.size
    assert [topics(:topic5)] == result
  end

  test "search date_to title" do
    search = Search.new( :date_to => '2009-06-25', :place => 'title')
    result = search.result
    assert_equal 1, result.size
    assert [topics(:one)] == result
  end
 
  test "search date_to post" do
    search = Search.new( :date_to => '2009-06-25', :place => 'post')
    result = search.result
    assert_equal 0, result.size
  end

  test "search date_from date_to all" do
    search = Search.new( :date_from => '2009-06-25', :date_to => '2009-06-26')
    result = search.result
    assert_equal 3, result.size
    assert [topics(:two)] + posts(:one, :two) == result
  end

  test "search title topics" do
    search = Search.new_ext({:place => 'title'}, [2, 3], nil)
    result = search.result
    assert_equal 2, result.size
    assert topics(:two, :opened) == result
  end

  test "search topics all" do
    search = Search.new_ext({}, [2, 3], nil)
    result = search.result
    assert_equal 4, result.size
    assert topics(:two, :opened) + posts(:for_opened_topic, :search1) == result
  end

  test "search title users" do
    search = Search.new_ext({:place => 'title'}, nil, [3, 4])
    result = search.result
    assert_equal 1, result.size
    assert [topics(:opened)] == result
  end

  test "search users all" do
    search = Search.new_ext({}, nil,  [2])
    result = search.result
    assert_equal 2, result.size
    assert [topics(:two)] + [posts(:three)] == result
  end
  
end
