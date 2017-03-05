Rails.application.routes.draw do
  devise_for :managers
  root to: 'home#index'
end
