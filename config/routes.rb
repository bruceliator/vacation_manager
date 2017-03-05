Rails.application.routes.draw do
  devise_for :managers
  root to: 'home#index'

  resources :managers do
    resources :vacations
  end

  resources :workers do
    resources :vacations
  end
end
