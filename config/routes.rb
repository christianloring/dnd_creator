Rails.application.routes.draw do
  root "home#index"

  resources :passwords, param: :token
  resource  :session,      only: %i[new create destroy]
  resource  :registration, only: %i[new create]
  resource :encounter, only: [ :new, :create, :show ]

  resources :characters do
    member do
      get  :play
      patch :update_game_profile
      post  :reset_game_profile
    end

    resources :runs,  only: %i[create]
    resources :notes, module: :characters
  end

  resources :campaigns do
    resources :notes, module: :campaigns
  end

  resources :npcs do
    collection do
      get :randomize
    end
  end

  get "dashboard", to: "home#dashboard", as: :dashboard

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
