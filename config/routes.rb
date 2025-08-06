Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "/static_pages/home", to: "static_pages#home", as: "home"

    # sign up
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    # login / logout
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    # user and nested resources
    resources :users, only: %i[new create show edit update] do
      resources :bookings, only: %i[index]
      resources :reviews, only: %i[index destroy]
      resource :password, only: %i[create edit update]
    end

    # Account Activations
    resources :account_activations, only: :edit

    resources :microposts

    resources :requests do
      member do
        patch :cancel
      end
    end
    
  end
end
