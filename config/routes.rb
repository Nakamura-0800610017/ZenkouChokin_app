Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "posts#index"

  resources :users, only: %i[new create show edit update destroy]
  resources :posts do
    collection do
      get :new_zenkou
      get :new_akugyou
      get :bookmarks
    end
  end
  resources :bookmarks, only: %i[create destroy]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  resources :user_points, only: %i[index]
  resources :password_resets, only: %i[new create edit update]
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  post "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  namespace :admin do
    root "posts#index"
    resources :posts, only: %i[index edit update destroy]
    resources :famous_quotes, only: %i[index new create edit update destroy]
    get "login" => "user_sessions#new", :as => :login
    post "login" => "user_sessions#create"
    delete "logout" => "user_sessions#destroy", :as => :logout
  end
end
