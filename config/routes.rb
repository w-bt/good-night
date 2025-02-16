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
        end
      end
    end
  end
end
