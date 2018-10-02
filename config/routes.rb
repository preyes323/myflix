Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#front_page'
  
  get 'ui(/:action)', controller: 'ui'
  get '/home'                          => 'videos#index',             as: 'home'
  get '/login'                         => 'sessions#new',             as: 'login'
  post '/login'                        => 'sessions#create'
  get '/logout'                        => 'sessions#destroy',         as: 'logout'
  post '/update_queue'                 => 'my_queues#update_queue',   as: 'update_queue'
  get '/people'                        => 'relationships#index',      as: 'people'
  get '/forgot_password'               => 'forgot_passwords#new',     as: 'forgot_password'
  get '/forgot_password_confirmation'  => 'forgot_passwords#confirm', as: 'forgot_password_confirmation'
  
  
  resources :videos, only: %i[index show] do
    collection do
      get :search, to: "videos#search"
    end

    member do
      post :review, to: "videos#review"
    end
  end
  
  resources :categories, only: :show
  resources :users, only: %i[index new create show]
  resources :my_queues, only: %i[index create destroy]
  resources :relationships, only: %i[create destroy]
  resources :forgot_passwords, only: %i[create]
end
