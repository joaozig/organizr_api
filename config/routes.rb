Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :create, :update, :destroy]

  resources :lists, only: [:index, :create, :update, :destroy] do
		resources :items, only: [:index, :create]
  end

  resources :sessions, only: [:create, :destroy]
end
