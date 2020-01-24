Rails.application.routes.draw do
  root to: 'streets#search'

  resources :streets, only: [:index, :show] do
    collection { get :search }
  end

  get 'ping', to: 'health#check'
end
