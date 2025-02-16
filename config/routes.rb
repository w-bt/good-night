Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          get :followers
          get :followees
          post :followees, to: "users#update_follow_status"

          get :clocks, to: "users#clocks"
          post :clocks, to: "users#update_clock"

          get "followees_clock/daily", to: "users#followees_clock_daily"
          get "followees_clock/weekly", to: "users#followees_clock_weekly"
        end
      end
    end
  end
end
