# Configuração das rotas da aplicação.
# Este arquivo define as rotas para autenticação de usuários, administração de questionários, templates e outras áreas do sistema.
Rails.application.routes.draw do
  # Configuração das rotas do Devise para usuários, incluindo sessões, registros, confirmações e senhas.
  devise_for :users, controllers: {
    # Personalização do controlador de sessões
    sessions: "users/sessions",
    # Personalização do controlador de registros de usuários
    registrations: "users/registrations",
    # Personalização do controlador de confirmações de email
    confirmations: "users/confirmations",
    # Personalização do controlador de recuperação de senhas
    passwords: "users/passwords"
  }

  # Redirecionamento e controle de rotas para usuários autenticados
  authenticated :user do
    # Redireciona o usuário autenticado para a página de dashboard (painel de controle)
    root to: "dashboard#index", as: :authenticated_root

    # Namespace para rotas administrativas, acessíveis apenas para usuários autenticados
    namespace :admin do
      # Página inicial do painel administrativo
      root to: "dashboard#index"

      # Rotas para gerenciar questionários dentro da área administrativa
      resources :questionnaires do
        # Sub-rotas para gerenciar submissões dentro de cada questionário
        resources :submissions, only: [ :index ]
      end

      # Rotas para gerenciar templates de questionários
      resources :templates do
        # Sub-rotas para criar e editar questões dentro de um template
        resources :questions, only: [ :new, :create, :edit, :update, :destroy ], controller: "templates/questions"
      end

      # Rotas para importar dados e gerar relatórios de resultados
      resources :imports, only: [ :new, :create ]
      resources :results, only: [ :index ]
    end

    # Rotas para questionários no frontend (visíveis para os usuários autenticados)
    resources :questionnaires, only: [ :show ] do
      # Sub-rotas para submissão de questionários
      resources :submissions, only: [ :new, :create ]
    end
  end

  # Página inicial para usuários não autenticados
  root to: "home#index"

  # Rotas para gerenciar assuntos (subjects)
  resources :subjects, only: [ :index, :show ]

  # Rota para o serviço de health check da aplicação
  get "up" => "rails/health#show", as: :rails_health_check

  # Rota para exportação de dados em formato CSV
  get "exportar/:id", to: "reports#export_to_csv", as: "exportar"
end
