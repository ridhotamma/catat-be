Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post "auth/login", to: "auth#login"

      # Users
      resources :users, only: [:index, :create, :show, :update] do
        collection do
          put "profile/change_password", to: "users#change_password"
          get "profile", to: "users#profile"
          put "profile", to: "users#update_profile"
        end
      end

      # Search Locations
      post "search_locations", to: "search_locations#search"

      # Attendance Settings, Departments, and Roles
      resources :attendance_settings, :departments, :roles, only: [:index, :create, :show, :update]

      # Organizations
      resources :organizations, only: [:index, :create, :show, :update] do
        member do
          get "attendance_settings", to: "organizations#attendance_settings"
          put "attendance_settings", to: "organizations#update_attendance_settings"
        end
      end

      # Attendance Requests
      resources :attendance_requests, only: [:index, :create, :show, :update] do
        member do
          post "approve"
          post "reject"
          post "cancel"
        end
        collection do
          post "clock_in", to: "attendance_requests#clock_in"
          post "clock_out", to: "attendance_requests#clock_out"
          get "all_requests", to: "attendance_requests#all_requests"
        end
      end
    end
  end
end
