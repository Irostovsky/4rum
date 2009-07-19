class Search < ActiveRecord::Base
	
  PLACES = [
    ['All', 'all'],
    ['Title', 'title'],
    ['Content', 'content'],
    ['Post', 'post']
  ]
  OCCURRENCES = [
    ['Full phrase', 'full'],
    ['By words', 'words']
  ]
  
  def self.to_selected_topics
    Topic.all.map{|topic| [topic.title[0..50] + '...', topic.id]}
  end
  
  def self.to_selected_users
    User.all.map{|user| [user.login, user.id]}    
  end
  
  def self.new_ext(simple_params, topic_ranges, user_ranges)
    search = new(simple_params)
    search.selected_topics = topic_ranges.join(',') if topic_ranges
    search.selected_users = user_ranges.join(',') if user_ranges 
    search  
  end
  
  def result_per_page(page)
  	result.paginate(:per_page => 10, :page => page)	
  end
  
  def result
    @result ||= result_from_topics + result_from_posts
  end
  
  def result_from_topics
     place == 'post' ? [] : Topic.find(:all, :order => 'id', :conditions => conditions('topic'))  	
  end

  def result_from_posts
     ['all', 'post'].include?(place) ? Post.find(:all, :order => 'id', :conditions => conditions('post')) : []  	
  end
  
  def conditions(type)
    array2_to_condition(' AND ', conditions_array(type))
  end

  def conditions_array(type)
    method_reg = Regexp.new("_#{type}_conditions$")
    methods.grep(method_reg).map{|m| send(m)}.compact
  end
  
  def keywords_topic_conditions
    if keywords
      case [place, occurrence]
        when ['title', 'full']: full_keywords_clause('title')
        when ['content', 'full']: full_keywords_clause('content')  		
        when ['all', 'full']: join_expr(
                                         ' OR ', 
                                         full_keywords_clause('title'), 
                                         full_keywords_clause('content')) 
        when ['title', 'words']: keywords_by_words_clauses('title')
        when ['content', 'words']: keywords_by_words_clauses('content')        
        when ['all', 'words']: join_expr(
                                          ' OR ', 
                                          keywords_by_words_clauses('title'), 
                                          keywords_by_words_clauses('content'))
      end  	
    end	  	
  end

  def keywords_post_conditions
    if keywords
      case occurrence
        when 'full': full_keywords_clause('content')
        when 'words': keywords_by_words_clauses('content')	
      end 
    end   	
  end 
  
  def date_from_conditions
    expr('created_at', '>=', date_from) if date_from
  end

  def date_to_conditions
    expr('created_at', '<=', date_to) if date_to
  end

  def selected_users_conditions
    expr('user_id', 'IN', selected_users.split(',')) if selected_users
  end

  alias date_from_topic_conditions date_from_conditions   

  alias date_from_post_conditions date_from_conditions   

  alias date_to_topic_conditions date_to_conditions   

  alias date_to_post_conditions date_to_conditions   
  
  alias selected_users_topic_conditions selected_users_conditions 
    
  alias selected_users_post_conditions selected_users_conditions   

  def selected_topics_topic_conditions
    expr('id', 'IN', selected_topics.split(',')) if selected_topics
  end

  def selected_topics_post_conditions
    expr('topic_id', 'IN', selected_topics.split(',')) if selected_topics
  end
  
  def keywords_by_words_clauses(field)
    arr = keywords.split(' ').map{|item| ["#{field} LIKE (?)", "%#{item}%"]}
    array2_to_condition(' AND ', arr)      
  end  

  def join_expr(delimiter,*expressions)
    array2_to_condition(delimiter, expressions)        
  end
    
  def array2_to_condition( delimiter, array2)
    expr = array2.map{|item| item.first}.join(delimiter)
    expr = "(#{expr})" unless expr.empty?
    params = [] 
    array2.each{|item| params += item[1..-1]}
    ["#{expr}"] + params      
  end

  def full_keywords_clause(field)
    expr(field, 'LIKE', "%#{keywords}%")
  end
  
  def expr(field, operation, value)
    ["#{field} #{operation} (?)", value]     
  end
 
end
