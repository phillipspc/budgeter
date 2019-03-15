Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "transactions#index"
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :transactions
  get "/recurring", to: "transactions#recurring", as: :recurring
  resources :categories do
    post "update_transactions_and_destroy", to: "categories#update_transactions_and_destroy", on: :member
  end
  resources :sub_categories do
    post "update_transactions_and_destroy", to: "sub_categories#update_transactions_and_destroy", on: :member
  end

  resources :plaid_items, only: :create
  resources :plaid_transactions, only: [:index, :new, :create]
end
