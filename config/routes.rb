Rails.application.routes.draw do
  root to: 'streets#search'

  resources :streets, only: [:show, :index] do
    collection { get :search }
  end
end
