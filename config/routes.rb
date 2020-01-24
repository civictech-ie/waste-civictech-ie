Rails.application.routes.draw do
  root to: 'streets#search'
  
  get '/:postcode/:street_slug', to: 'streets#show'
  resources :streets, only: [:index, :show] do
    collection { get :search }
  end

  namespace :api do
    namespace :v1 do
      resources :streets, only: [:index, :show] do
        collection { get :search }
      end
    end
  end

  get 'ping', to: 'health#check'
end
