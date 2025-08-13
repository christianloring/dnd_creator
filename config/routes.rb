Rails.application.routes.draw do
  root "home#index"

  resources :passwords, param: :token
  resource  :session,      only: %i[new create destroy]
  resource  :registration, only: %i[new create]

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

  get "dashboard", to: "home#dashboard", as: :dashboard

  # Legal pages
  get "privacy", to: "legal#privacy", as: :privacy
  get "terms", to: "legal#terms", as: :terms

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
