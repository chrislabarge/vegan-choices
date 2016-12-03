Rails.application.routes.draw do
  get 'home', :to => "static#index"
  root :to => "static#index"

  resources :restaurants
  resources :items do
    member do
      get :ingredients
    end
  end
end
