Rails.application.routes.draw do
  get "/zomg", to: "customers#zomg", as: 'zomg'

  # Movies
  resources :movies, only: [:index, :show, :create]
  get '/movies/:id/current', to: 'movies#current', as: 'movies_current'
  get '/movies/:id/history', to: 'movies#history', as: 'movies_history'

  # Customers
  resources :customers, only: [:index]
  get '/customers/:id/current', to: 'customers#current', as: 'customers_current'
  get '/customers/:id/history', to: 'customers#history', as: 'customers_history'

  #Rentals
  post '/rentals/check-out', to: 'rentals#checkout', as: 'check_out'
  post '/rentals/check-in', to: 'rentals#checkin', as: 'check_in'
  get '/rentals/overdue', to: 'rentals#overdue', as: 'overdue'
end
