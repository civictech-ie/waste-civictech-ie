Rails.application.routes.draw do
  root to: 'streets#search'
  resources :streets
end
