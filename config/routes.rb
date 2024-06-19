Rails.application.routes.draw do
  devise_for :users
  root to: "pages#splash_screen"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :books, only: [:index, :show, :new, :create, :update] do
    resources :collections, only: [:destroy, :create]
  end
  resources :collections, only: [:update]
  resources :series, only: [:show, :index]
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  get '/collections/:id/favorite', to: "collections#favorite", as: :favorite_collection
  get '/collections/:id/read', to: "collections#read", as: :read_collection
  get '/home', to: 'pages#home'
end
