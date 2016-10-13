Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :create, :update, :destroy]
  resources :lists, only: [:index, :create, :update]
  resources :sessions, only: [:create, :destroy]
end
