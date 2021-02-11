Rails.application.routes.draw do
  get 'status', to: 'status#index'

  namespace :testing do
    namespace :api do
      resources :plan_dates, only: [:index]
      resources :regions, only: [:index]
      resources :counties, only: [:index]
      resources :moms, only: [:index]
      resources :latest_snapshots, only: [:index]
    end

    root to: 'dashboard#index'
  end

  namespace :vaccination do
    resources :subscriptions, only: [:index, :create, :destroy]

    root to: 'dashboard#index'
  end

  get 'cookies', to: 'pages#cookies', as: 'cookies_page'

  mount Facebook::Messenger::Server, at: 'bot'
  scope :firebase do
    get 'configuration', to: 'firebase#configuration'
  end

  get 'crash', to: 'application#crash'

  root to: 'testing/dashboard#index'
end
