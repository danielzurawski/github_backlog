GithubBacklog::Application.routes.draw do


  get "history/index"

  #Authentication's routes
  get '/logout', :to => 'sessions#destroy'
  get '/save_token/', :to => 'session#save_token'
  get   '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  #Project's routes
  get "project", :to => 'project#list'
  get "project/new"
  get "project/show/:scope/:name", :to => 'project#show'
  get "project/list"
  get "project/edit/:scope/:name", :to  => 'project#edit'
  get "project/link/:scope/:name", :to  => 'project#link'
  get "project/revoke/:scope/:name/:user_id", :to => 'project#revoke'
  get "project/grant/:scope/:name", :to => 'project#grant'
  get "project/delete/:scope/:name", :to  => 'project#delete'
  get "project/unlink/:scope/:name/:repo_id", :to => 'project#unlink'
  post "project/select_project"
  post "project/linked"
  post "project/create"
  post "project/grant/:scope/:name", :to => 'project#grant'
  put "project/edit/:scope/:name", :to  => 'project#edit'
  resources :user do
    get :autocomplete_user_login, :on => :collection
  end

  #Backlog's routes
  get "backlog/:scope/:name" ,:to => 'backlog#index'
  get "backlog/show/:scope/:name/:identifier", :to => 'backlog#show'
  get "backlog/ready/:scope/:name/:identifier", :to => 'backlog#ready'
  get "backlog/draft/:scope/:name/:identifier", :to => 'backlog#draft'
  get "backlog/accept/:scope/:name/:identifier", :to => 'backlog#accept'
  get "backlog/reject/:scope/:name/:identifier", :to => 'backlog#reject'
  get "backlog/progress/:scope/:name/:identifier", :to => 'backlog#progress'
  get "backlog/delete/:scope/:name/:identifier", :to => 'backlog#delete'
  get "backlog/edit/:scope/:name/:identifier", :to => 'backlog#edit'
  post "backlog/create"
  post "backlog/reorder"
  put "backlog/edit/:scope/:name/:identifier", :to => 'backlog#edit'
    
  #Planning's view
  get "planning/:scope/:name", :to => 'planning#index'
  get "planning/card/:scope/:name/:identifier", :to => 'planning#card'
  get "planning/close/:scope/:name", :to => 'planning#close'
  post "planning/reorder", :to => 'planning#reorder'
  
  #History view
  get "history/:scope/:name", :to => 'history#index'
  




  get "home/index"




  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
