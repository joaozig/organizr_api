Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :create, :update, :destroy]
  resources :sessions, only: [:create, :destroy]
end
