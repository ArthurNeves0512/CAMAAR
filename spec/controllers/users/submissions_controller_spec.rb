require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe SubmissionsController, type: :controller do
  before(:all) do
    Warden.test_mode!
  end

  after(:all) do
    Warden.test_reset!
  end

  let!(:user) do
    User.create!(
      nome: "Estudante",
      email: "estudante@example.com",
      matricula: "2110320991",
      password: "senha123",
      password_confirmation: "senha123",
      role: 0  # Student
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

  let!(:questionnaire) do
    Questionnaire.create!(
      name: "Questionário 1",
      template: template,
      classroom_info: "A123"
    )
  end

  # Simulate an invalid submission where the save fails
  let(:invalid_submission_params) do
    {
      questionnaire_id: questionnaire.id,
      submission: {
        answers: {}  # Empty answers to force validation failure
      }
    }
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(controller).to receive(:authenticate_user!).and_return(true)
    login_as(user, scope: :user)
  end

  describe 'POST #create' do
    context 'when submission fails to save' do
      before do
        # Stub the save method to return false, simulating a failed save
        allow_any_instance_of(Submission).to receive(:save).and_return(false)
      end

      it 'sets the flash alert and renders the questionnaire show template' do
        post :create, params: invalid_submission_params

        expect(flash[:alert]).to eq("Erro ao enviar a avaliação. Verifique suas respostas.")
        expect(response).to render_template("questionnaires/show")
      end
    end
  end
end
