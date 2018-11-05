Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  # get "/zomg", to: ""
  # post '/rentals/check-out', to: 'movies#checkout', as: 'checkout'
  # post '/rentals/check-in', to: 'movies#checkin', as: 'checkin'
end
