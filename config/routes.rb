Rails.application.routes.draw do
  resources :rules_engines

  resources :application_details

  get 'app_setup/create'
  get 'home/index'
  get '/home/test' => redirect("http://localhost:3001/")
  get '/JSON_PORTAL/list' => "application_details#index"
  get '/rules_engine/search/' => "rules_engines#search" , as: :rules_engines_search_path 
  get '/JSON_PORTALS/search/' => "application_details#search" , as: :app_details_search_path 
  get '/JSON_PORTAL/create' => "app_setup#create"
  get '/JSON_PORTAL/RestAPI' => "app_setup#create"
  get '/JSON_PORTAL/format' => "home#index"
  get '/JSON_PORTAL/:id/edit' => "application_details#edit"
  get    '/JSON_PORTAL/:id'   =>    "application_details#show"
  patch  '/JSON_PORTAL/:id'  =>    "application_details#update"
  put    '/JSON_PORTAL/:id'   =>    "application_details#update"
  delete '/JSON_PORTAL/:id'   =>   "application_details#destroy"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  resources :home do
    post :to_html, on: :collection
  end
  resources :rules_engines do
    post :export_rule_backend, on: :collection
  end  
  post '/home/json_to_html' => 'home#json_to_html', as: :json_to_html_path
  post '/rules_engines/export_rules' => 'rules_engines#export_rules', as: :export_rules_path
  post '/app_setup/save_record' => 'app_setup#save_record', as: :save_app_setup_path
  post '/app_setup/test_Conn' => 'app_setup#test_Conn'
  post '/application_details/test_Conn' => "application_details#test_Conn", as: :test_conn_path


end
