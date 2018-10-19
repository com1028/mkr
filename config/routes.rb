Rails.application.routes.draw do
  root 'home#index'
  get  '/home', to: 'home#index'
  get '/login', to: 'home#authentication' 
  devise_for :users
  resources :mercari_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
