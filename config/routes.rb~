ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'topics'
  map.resources :searches
  map.resources :users, :has_many => [:statuses, :photos]
  map.resource :session
  map.resources :topics, :has_many => [:posts, :states]
  	 
end
