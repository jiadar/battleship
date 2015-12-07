Rails.application.routes.draw do

  # Constrain our API to only respond with JSON responses
  namespace :api, constraints: { format: 'json' } do
    namespace :v1, constraints: { format: 'json' } do
      resources :games, only: [:create]

      # GUID-related Games routes
      get '/games/:guid', to: 'games#show' # Get game info
      put '/games/:guid/join', to: 'games#join' # Join a created game by GUID
      put '/games/:guid/update', to: 'games#update' # PUT a move order

      # GUID-related nester Boards routes
      get '/games/:guid/board', to: 'boards#show'
      put 'games/:guid/board', to: 'boards#update'
    end
  end

  resource :sessions, only: [:create, :destroy]
  resource :users, only: [:create]

end
