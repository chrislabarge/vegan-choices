Rails.application.routes.draw do
  root to: 'static#index'

  get 'home', to: 'static#index'
  get 'about', to: 'static#about'
  get 'search/restaurants', to: 'search#restaurants'

  resources :restaurants
  resources :contacts, only: [:new, :create]
  resources :items do
    member do
      get :item_ingredients
    end
  end

  get 'select_item_type', to: 'items#type_form'
end

