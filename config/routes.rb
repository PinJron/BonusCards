Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  resources :cards, only: %i[index show]
  resources :shops, only: %i[index show update create]
  resources :users, only: %i[index show update create]

  post '/shops/:id/buy', to: 'shops#buy', as: 'buy'
end
