Rails.application.routes.draw do
  resources :receipts
  resources :members
  get 'welcome/index'

  resources :members do 
    resources :receipts
  end

  root to: "welcome#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
