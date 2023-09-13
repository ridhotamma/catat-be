Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'users', to: 'users#index'
      post 'users', to: 'users#create'
      get 'users/:id', to: 'users#show'
      put 'users/:id', to: 'users#update'

      put 'profile/change_password', to: 'users#change_password'
      get 'profile', to: 'users#profile'
      put 'profile', to: 'users#update_profile'

      post 'auth/login', to: 'auth#login'

      resources :attendance_settings
      resources :departments
      resources :roles
      resources :organizations do
        get 'attendance_settings', on: :member
      end

      post 'attendance_requests/clock_in', to: 'attendance_requests#clock_in'
      post 'attendance_requests/clock_out', to: 'attendance_requests#clock_out'
      get 'attendance_requests/all', to: 'attendance_requests#all_requests'

      resources :attendance_requests do
        member do
          post 'approve'
          post 'reject'
          post 'cancel'
        end
      end
    end
  end
end