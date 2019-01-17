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
    resources :sub_categories
  end
end
