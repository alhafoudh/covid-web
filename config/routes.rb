Rails.application.routes.draw do
  namespace :testing do
    namespace :api do
      resources :test_dates, only: [:index]
      resources :regions, only: [:index]
      resources :counties, only: [:index]
      resources :moms, only: [:index]
      resources :latest_test_date_snapshots, only: [:index]
    end

    root to: 'dashboard#index'
  end

  root to: 'testing/dashboard#index'
end
