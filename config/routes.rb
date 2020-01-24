Rails.application.routes.draw do
  root to: 'streets#search'
  
  get 'streets/:postcode/:street_slug', to: 'streets#show'
  resources :streets, only: [:index, :show] do
    collection { get :search }
  end

  get 'ping', to: 'health#check'
end
