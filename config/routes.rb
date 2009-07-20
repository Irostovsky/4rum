ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'topics'
  map.resources :searches
  map.resources :users do |user|
    user.resources :statuses
    user.resources :photos, :has_many => [:photos_managements] 
  end
  map.resource :session
  map.resources :topics, :has_many => [:posts, :states]
  	 
end
