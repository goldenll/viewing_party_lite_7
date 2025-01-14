# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"
  get "/login", to: "users#login_form"
  post "/login", to: "users#login_user"
  get "/logout", to: "users#destroy"
  delete "/logout", to: "users#destroy"
  get "/dashboard", to: "dashboard#index"
  get "/admin/users/:id", to: "admin/users#show"

  get "register", to: "users#new", as: :new_user
  resources :users, only: [:create, :show] do
    get "discover", to: "users/discover#index"
    resources :movies, only: [:index, :show], controller: "users/movies" do
      resources :viewing_party, only: [:new, :create], controller: "users/movies/viewing_parties"
    end
  end
  namespace :admin do 
    get "/dashboard", to: "dashboard#index"
  end
end
