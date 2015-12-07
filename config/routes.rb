Rails.application.routes.draw do

  # Constrain our API to only respond with JSON responses
  namespace :api, constraints: { format: 'json' } do
    namespace :v1, constraints: { format: 'json' } do
      resources :games, only: [:create]
      put '/games/:guid/join', to: 'games#join'
      get '/games/:guid', to: 'games#show'
    end
  end

  resource :sessions, only: [:create, :destroy]
  resource :users, only: [:create]

end
