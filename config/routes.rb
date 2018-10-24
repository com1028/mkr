Rails.application.routes.draw do
  root 'home#index'
  get  '/home', to: 'home#index'
  get '/login', to: 'home#authentication' 
  post '/delete_selected_mercari_account', to: 'mercari_users#delete_selected_user'
  post '/delete_selected_item', to: 'items#delete_selected_item'
  post '/update_selected_item', to: 'items#update_selected_item'
  devise_for :users
  resources :mercari_users
  resources :items
end
