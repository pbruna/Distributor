Distributor::Application.routes.draw do
  match "/servers/:id/activate" => "servers#activate", :as => "activate_server"
  devise_for :users
  
  resources :users
  resources :servers
  devise_scope :user do
    root :to => "devise/sessions#new"
  end
end
