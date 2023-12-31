Rails.application.routes.draw do
  devise_for :users
  root to: "transactions#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_scope :user do
    resources :users
  end

  resources :transactions
  post 'transactions/update_group_status', to: 'transactions#update_group_status', as: 'update_group_status_transactions'
  resources :expenses
  resources :groups
  resources :incomes
  resources :goals do
    member do
      patch :favorite
    end
  end
end
