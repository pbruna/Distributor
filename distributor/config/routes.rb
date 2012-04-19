Distributor::Application.routes.draw do
  devise_for :users
  
  resources :users
  resources :servers
  devise_scope :user do
    root :to => "devise/sessions#new"
  end
end
