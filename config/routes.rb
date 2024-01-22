Rails.application.routes.draw do
  resources :jobs, only: [:index, :show]
  root 'jobs#index'
end
