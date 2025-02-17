require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Admin::QuestionnairesController, type: :controller do
  before(:all) do
    Warden.test_mode!
  end

  after(:all) do
    Warden.test_reset!
  end

  let!(:user_adm) do
    User.create!(
      nome: "Janilson",
      email: "adm1@example.com",
      matricula: "2110320991",
      password: "senha123",
      password_confirmation: "senha123",
      role: 2  # Admin
    )
  end

  let!(:teacher) do
    User.create!(
      nome: "Professor",
      email: "professor@example.com",
      matricula: "123456789",
      password: "senha123",
      password_confirmation: "senha123",
      role: 1  # Professor
    )
  end

  let!(:department) { Department.create!(name: "Departamento de Exemplo") }
  let!(:subject) { Subject.create!(name: "Matemática", code: "MAT123", department: department) }
  let!(:template) do
    Template.create!(
      name: "Template 1",
      target_audience: "Estudantes",
      semester: "2024/2"
    )
  end

  let!(:classroom) do
    Classroom.create!(
      code: "A123",
      semester: "2024/2",
      time: "08:00",
      subject: subject,
      teacher_id: teacher.id
    )
  end

  let(:valid_params) do
    {
      template_id: template.id,
      classroom_codes: [ classroom.code ],
      name: "Questionário 1"
    }
  end

  let(:invalid_params) do
    {
      template_id: nil,
      classroom_codes: nil,  # Simula ausência deste parâmetro
      name: ""
    }
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # Bypass dos callbacks de autenticação e autorização
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:authorize_admin!).and_return(true)
    login_as(user_adm, scope: :user)
  end

  describe 'GET #index' do
    it 'retorna todos os questionários, templates e turmas' do
      Questionnaire.create!(name: 'Questionário 1', template: template, classroom_info: "A123")
      Template.create!(name: 'Template 2', target_audience: 'Professores', semester: '2024/1')
      Classroom.create!(
        code: 'B123',
        semester: '2024/2',
        time: "10:00",
        subject: subject,
        teacher_id: teacher.id
      )

      get :index, params: {}, format: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["questionnaires"].size).to eq(1)
      expect(json["templates"].size).to eq(2)
      expect(json["classrooms"].size).to eq(2)
    end
  end

  describe 'POST #create' do
    context 'quando os parâmetros são válidos' do
      it 'cria um novo questionário com sucesso' do
        expect {
          post :create, params: valid_params, format: :json
        }.to change(Questionnaire, :count).by(1)

        expect(flash[:notice]).to eq("✅ Formulários criados com sucesso.")
      end
    end

    context 'quando os parâmetros são inválidos' do
      it 'não cria o questionário e retorna erro' do
        expect {
          post :create, params: invalid_params, format: :json
        }.not_to change(Questionnaire, :count)

        expect(flash[:alert]).to eq("❌ Erro de processamento.")
      end
    end
  end

  describe 'GET #show' do
    let(:questionnaire) do
      Questionnaire.create!(name: "Questionário 1", template: template, classroom_info: "A123")
    end

    it 'retorna o questionário correto' do
      get :show, params: { id: questionnaire.id }, format: :json

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(questionnaire.id)
    end
  end
end
