Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: redirect('/up')

  namespace :api do
    resources :users, only: %i[index create], path: 'user'

    resources :sessions, only: [:create]

    resource :user, only: [] do
      resources :game_events, only: [:create]
    end
  end
end
