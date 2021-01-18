Rails.application.routes.draw do
  resources :regions, only: [:index, :show] do
    resources :counties, only: [:show] do
      resources :moms, only: [:index]
    end
  end

  root to: 'regions#index'
end
