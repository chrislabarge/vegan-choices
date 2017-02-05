Rails.application.routes.draw do
  root to: 'static#index'

  get 'home', to: 'static#index'
  get 'about', to: 'static#about'
  get 'search/restaurants', to: 'search#restaurants'

  resources :restaurants
  resources :items do
    member do
      get :item_ingredients
    end
  end
end

