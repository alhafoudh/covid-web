require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user do
    namespace :admin do
      mount Sidekiq::Web, at: '/sidekiq'
    end
  end

  get 'status', to: 'status#index'

  namespace :testing do
    namespace :api do
      resources :plan_dates, only: [:index]
      resources :regions, only: [:index]
      resources :counties, only: [:index]
      resources :moms, only: [:index]
      resources :latest_snapshots, only: [:index]
    end

    get 'embed', to: 'dashboard#embed'

    root to: 'dashboard#index'
  end

  namespace :vaccination do
    #   resources :subscriptions, only: [:index, :create, :destroy]
    #
    #   get 'embed', to: 'dashboard#embed'
    #
    root to: 'dashboard#index'
  end

  get 'cookies', to: 'pages#cookies', as: 'cookies_page'
  get 'about', to: 'pages#about', as: 'about_page'

  mount Facebook::Messenger::Server, at: 'bot'
  scope :firebase do
    get 'configuration', to: 'firebase#configuration'
  end

  get 'crash', to: 'application#crash'

  root to: 'testing/dashboard#index'
end
