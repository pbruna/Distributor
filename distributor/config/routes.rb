Distributor::Application.routes.draw do
  match "/servers/:id/sincronize" => "servers#sincronize", :as => "sincronize_server"
  match "/packages/:id/sincronize" => "packages#sincronize", :as => "sincronize_package"
  match "/servers/:id/activate" => "servers#activate", :as => "activate_server"
  devise_for :users
  
  resources :jobs
  resources :packages
  resources :users
  resources :servers
  devise_scope :user do
    root :to => "devise/sessions#new"
  end
end
