Rails.application.routes.draw do
  devise_for :users
  root to: 'static#index'

  get 'home', to: 'static#index'
  get 'about', to: 'static#about'
  get 'search/restaurants', to: 'search#restaurants'
  get 'sitemap', to: 'static#sitemap'
  get 'privacy-policy', to: 'static#privacy_policy'
  get 'terms', to: 'static#terms'

  resources :restaurants
  resources :users
  resources :contacts, only: [:new, :create]
  resources :items do
    member do
      get :item_ingredients
    end
  end
end

