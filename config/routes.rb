Rails.application.routes.draw do
  root to: 'streets#search'

  resources :streets, only: [:show] do
    collection { get :search }
  end
end
