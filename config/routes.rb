Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'static#index'

  get 'home', to: 'static#index'
  get 'about', to: 'static#about'
  get 'search/restaurants', to: 'search#restaurants'
  get 'sitemap', to: 'static#sitemap'
  get 'privacy-policy', to: 'static#privacy_policy'
  get 'terms', to: 'static#terms'

  resources :restaurants do
    member do
      get :comments
    end
  end

  resources :users
  resources :contacts, only: [:new, :create]
  resources :comments, only: [:edit, :update, :destroy]

  resources :item_comments, only: [:new, :create]
  resources :restaurant_comments, only: [:new, :create]
  resources :reply_comments, only: [:new, :create]

  resources :items do
    member do
      get :item_ingredients
    end

    member do
      get :comments
    end
  end
end

