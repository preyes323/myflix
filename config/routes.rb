Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#front_page'
  
  get 'ui(/:action)', controller: 'ui'
  get '/home' => 'videos#index', as: 'home'
  get '/login' => 'sessions#new', as: 'login'
  
  resources :videos, only: %i[index show] do
    collection do
      get :search, to: "videos#search"
    end
  end
  
  resources :categories, only: :show
  resources :users, only: %i[new create]
end
