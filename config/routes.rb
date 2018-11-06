Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]

  # get "/zomg", to: ""
  post '/rentals/check_out', to: 'movies#check_out', as: 'check_out'
  post '/rentals/check_in', to: 'movies#check_in', as: 'check_in'
end
