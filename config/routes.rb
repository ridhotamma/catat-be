Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'users#create'
      post 'auth/login', to: 'users#login'
      get 'users', to: 'users#index'
      get 'users/:id', to: 'users#show'
      put 'users/:id', to: 'users#update'
    end
  end
end