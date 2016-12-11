Rails.application.routes.draw do
  get 'home', :to => "static#index"
  post 'restaurant_search', to: 'static#restaurant_search'

  root :to => "static#index"

  resources :restaurants
  resources :items do
    member do
      get :ingredients
    end
  end
end
