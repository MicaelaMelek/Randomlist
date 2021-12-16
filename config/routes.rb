Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Artists
      get '/artists', to: 'artists#index'

      #Albums
      get '/artists/:artist_id/albums', to: 'albums#index', as: 'albums'

      #Tracks
      get '/tracks', to: 'tracks#index'
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/users/auth/callback', to: 'users/omniauth_callbacks#spotify'


  #Playlist
  resources :playlists

  root to: 'playlists#new'
end
