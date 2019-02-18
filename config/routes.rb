Rails.application.routes.draw do
	require 'sidekiq/web'
  Sidekiq::Web.set :sessions, false
  mount Sidekiq::Web => '/sidekiq'

  root "sale_files#index"

  resources :sale_files
end
