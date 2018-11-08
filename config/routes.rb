Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  get "/zomg", to: "customers#zomg", as: 'zomg'
  post '/rentals/check-out', to: 'rentals#checkout', as: 'check_out'
  post '/rentals/check-in', to: 'rentals#checkin', as: 'check_in'
end
