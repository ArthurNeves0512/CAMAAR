require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe ReportsController, type: :controller do
  before(:all) do
    Warden.test_mode!
  end

  after(:all) do
    Warden.test_reset!
  end

  let!(:admin_user) do
    User.create!(
      nome: "Admin User",
      email: "admin@example.com",
      matricula: "2110320991",
      password: "password123",
      password_confirmation: "password123",
      role: 2  # Admin
    )
  end

  let!(:teacher_user) do
    User.create!(
      nome: "Teacher User",
      email: "teacher@example.com",
      matricula: "123456789",
      password: "password123",
      password_confirmation: "password123",
      role: 1  # Teacher
    )
  end

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
      classroom_info: "A123",
      template_id: template.id
    )
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    login_as(teacher_user, scope: :user)  # Login as a non-admin user
  end

  describe "GET #export_to_csv" do
    context "when user is not an admin" do
      before do
        # Ensure current_user is set properly by setting the request.env
        @request.env["warden"].set_user(teacher_user)

        get :export_to_csv, params: { id: questionnaire.id }
      end

      it "redirects to authenticated root path with an alert" do
        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:alert]).to eq("Você precisa ser um administrador para acessar essa página.")
      end
    end
  end
end
