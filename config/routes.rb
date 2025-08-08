Rails.application.routes.draw do
  root "home#index"

  resources :passwords, param: :token

  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]

  resources :characters do
    member { get :play }
    member { patch :update_game_profile }
    member { post :reset_game_profile }
    resources :runs, only: [ :create ]
  end
  resources :characters do
    resources :notes, module: :characters
  end

  resources :campaigns do
    resources :notes, module: :campaigns
  end

  get "dashboard", to: "home#dashboard", as: :dashboard

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
