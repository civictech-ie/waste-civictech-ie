Rails.application.routes.draw do
  root to: 'streets#index'
  resources :streets
end
