require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    # Define o mapeamento do Devise para :user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # Evita que o filtro require_no_authentication interfira
    allow(controller).to receive(:require_no_authentication)
  end

  describe 'POST #create' do
    context 'quando o e-mail está em branco' do
      it 'redireciona para new_user_password_path com alerta' do
        post :create, params: { user: { email: "" } }
        expect(response).to redirect_to(new_user_password_path)
        expect(flash[:alert]).to eq("O campo de e-mail não pode estar vazio.")
      end
    end

    context 'quando o e-mail é informado' do
      let!(:user) do
        User.create!(
          email: "teste@example.com",
          password: "senha123",
          password_confirmation: "senha123",
          confirmed_at: Time.current,
          matricula: "12345",
          nome: "Teste User"
        )
      end

      context 'quando o usuário é encontrado e o token é gerado com sucesso' do
        it 'redireciona para a página de edição com notice' do
          # Força o stub em qualquer instância para garantir que o token seja "fake-token"
          allow_any_instance_of(User).to receive(:send_reset_password_instructions).and_return("fake-token")
          allow(controller).to receive(:successfully_sent?).with(user).and_return(true)

          post :create, params: { user: { email: "teste@example.com" } }
          expect(response).to redirect_to(edit_user_password_path(reset_password_token: "fake-token"))
          expect(flash[:notice]).to eq("Usuário encontrado! Agora defina sua nova senha.")
        end
      end

      context 'quando o usuário é encontrado, mas o token não é gerado com sucesso' do
        it 'redireciona para new_user_password_path com alerta de erro' do
          allow_any_instance_of(User).to receive(:send_reset_password_instructions).and_return("fake-token")
          allow(controller).to receive(:successfully_sent?).with(user).and_return(false)

          post :create, params: { user: { email: "teste@example.com" } }
          expect(response).to redirect_to(new_user_password_path)
          expect(flash[:alert]).to eq("Erro ao gerar o link de redefinição de senha.")
        end
      end

      context 'quando o usuário não é encontrado' do
        it 'redireciona para new_user_password_path com alerta informando que o usuário não foi localizado' do
          post :create, params: { user: { email: "inexistente@example.com" } }
          expect(response).to redirect_to(new_user_password_path)
          expect(flash[:alert]).to eq("Usuário não encontrado. Verifique o e-mail informado.")
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'quando o parâmetro reset_password_token está ausente' do
      it 'redireciona para new_user_password_path com alerta de token inválido' do
        get :edit, params: {}
        expect(response).to redirect_to(new_user_password_path)
        expect(flash[:alert]).to eq("Token inválido ou expirado. Solicite a recuperação de senha novamente.")
      end
    end

    context 'quando o token é informado' do
      let!(:user) do
        User.create!(
          email: "user@example.com",
          password: "senha123",
          password_confirmation: "senha123",
          confirmed_at: Time.current,
          matricula: "67890",
          nome: "User Example"
        )
      end
      let(:token) { "valid-token" }

      context 'e o token é válido' do
        before do
          allow(User).to receive(:with_reset_password_token).with(token).and_return(user)
        end

        it 'atribui @user e renderiza o template edit' do
          get :edit, params: { reset_password_token: token }
          # Para usar assigns, adicione gem "rails-controller-testing" ao Gemfile
          expect(assigns(:user)).to eq(user)
          expect(response).to render_template(:edit)
        end
      end

      context 'e o token é inválido' do
        before do
          allow(User).to receive(:with_reset_password_token).with("invalid-token").and_return(nil)
        end

        it 'redireciona para new_user_password_path com alerta' do
          get :edit, params: { reset_password_token: "invalid-token" }
          expect(response).to redirect_to(new_user_password_path)
          expect(flash[:alert]).to eq("Token inválido ou expirado. Tente novamente.")
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) do
      User.create!(
        email: "user2@example.com",
        password: "senha123",
        password_confirmation: "senha123",
        confirmed_at: Time.current,
        matricula: "11111",
        nome: "User Two"
      )
    end
    let(:update_params) do
      { user: { reset_password_token: "token", password: "nova_senha", password_confirmation: "nova_senha" } }
    end

    context 'quando a atualização da senha é bem-sucedida' do
      before do
        allow(User).to receive(:reset_password_by_token)
          .with(ActionController::Parameters.new(update_params[:user]).permit!)
          .and_return(user)
        allow(user).to receive_message_chain(:errors, :empty?).and_return(true)
      end

      it 'realiza o login e redireciona para a root com notice' do
        patch :update, params: update_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Senha alterada com sucesso! Você está logado.")
      end
    end

    context 'quando há erros na atualização da senha' do
      before do
        allow(User).to receive(:reset_password_by_token)
          .with(ActionController::Parameters.new(update_params[:user]).permit!)
          .and_return(user)
        allow(user).to receive_message_chain(:errors, :empty?).and_return(false)
      end

      it 'redireciona de volta para a edição com alerta de erro' do
        patch :update, params: update_params
        expect(response).to redirect_to(edit_user_password_path(reset_password_token: update_params[:user][:reset_password_token]))
        expect(flash[:alert]).to eq("Erro ao atualizar a senha. Verifique os dados e tente novamente.")
      end
    end
  end
end
