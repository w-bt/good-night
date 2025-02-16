Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          get :followers
          get :followees
          post :followees, to: "users#update_follow_status"

          post :clocks, to: "users#update_clock"
        end
      end
    end
  end
end
