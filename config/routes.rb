Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root

    namespace :admin do
      root to: 'dashboard#index'
      resources :questionnaires do
      resources :submissions, only: [:index]
      end
      resources :templates
      resources :imports, only: [:new, :create]
    end

    resources :questionnaires, only: [:index, :show] do
    resources :submissions, only: [:new, :create]
    end
  end

  root to: "home#index"
  resources :subjects, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end