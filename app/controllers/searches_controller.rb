class SearchesController < ApplicationController
  before_filter :logged_user_filter
  
  def new
    @search = Search.new()
  end

  def index
    @search = Search.new_ext(params[:search], params[:topic_ranges], params[:user_ranges] )
    @search_result = @search.result_per_page(params[:page])
  end

end
