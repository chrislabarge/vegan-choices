Rails.application.routes.draw do
  get 'home', :to => "static#index"
  root :to => "static#index"

  resources :restaurants
end
