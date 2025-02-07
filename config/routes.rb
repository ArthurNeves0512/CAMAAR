Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                       confirmations: "users/confirmations",
                       passwords: 'users/passwords'
                     }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root

    namespace :admin do
      root to: "dashboard#index"
      
      # Questionários
      resources :questionnaires do
        resources :submissions, only: [:index]
      end

      # Templates
      resources :templates do
        # Rotas para criar e excluir questões dentro do template
        resources :questions, only: [:new, :create, :edit, :update, :destroy], controller: 'templates/questions'
      end

      resources :imports, only: [:new, :create]
      resources :results, only: [:index]
    end

    # Questionários no frontend
    resources :questionnaires, only: [:index, :show] do
      resources :submissions, only: [:new, :create]
    end
  end

  root to: "home#index"
  resources :subjects, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
  get "exportar/:id", to: "reports#export_to_csv", as: "exportar"
end
