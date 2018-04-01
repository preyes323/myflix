Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'ui(/:action)', controller: 'ui'
  get '/home' => 'videos#index', as: 'home'
  get '/videos/search' => 'videos#search', as: 'search'

  resources :videos, only: %i[index show]
  resources :categories, only: :show
end
