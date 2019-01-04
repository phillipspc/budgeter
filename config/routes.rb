Rails.application.routes.draw do
  devise_for :users
  root to: "transactions#index"

  resources :transactions
  get "/recurring", to: "transactions#recurring", as: :recurring
  resources :categories do
    resources :sub_categories
  end
end
