Rails.application.routes.draw do
  devise_for :users
  root to: "transactions#index"

  resources :transactions
  resources :categories do
    resources :sub_categories
  end
end
