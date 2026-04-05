Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "books#index"

  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users, only: %i[create show edit update]

  resources :books, only: %i[index show] do
    resources :borrowings, only: [:create]
  end

  resources :borrowings, only: %i[index update]

  namespace :admin do
    root "dashboard#show"
    resources :books
    resources :categories
    resources :users, only: %i[index show edit update]
    resources :borrowings, only: %i[index show edit update]
  end
end
