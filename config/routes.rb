Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  # post '/rentals/check-out', to: 'movies#checkout', as: 'checkout'
  # post '/rentals/check-in', to: 'movies#checkin', as: 'checkin'
end
