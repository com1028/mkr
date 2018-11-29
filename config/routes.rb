Rails.application.routes.draw do
  root 'home#index'
  get  '/home', to: 'home#index'
  get '/login', to: 'home#authentication' 
  post '/delete_mercari_account', to: 'mercari_users#delete_selected_user'
  post '/update_mercari_auth_token', to: 'mercari_users#update_mercari_auth_token'
  post '/delete_item_from_mercari', to: 'items#delete_item_from_mercari'
  post '/delete_item', to: 'items#delete_item'
  post '/exhibit', to: 'items#simple_exhibit'
  post '/start_auto_exhibit', to: 'items#start_auto_exhibit'
  post '/stop_auto_exhibit', to: 'items#stop_auto_exhibit'
  devise_for :users
  resources :mercari_users
  resources :items
end
