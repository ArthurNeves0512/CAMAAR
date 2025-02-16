require "rails_helper"

RSpec.feature "Importar dados do SIGAA", type: :feature do
  let(:admin_user) do
    User.create!(
      nome: "Janilson",
      email: "adm1@example.com",
      matricula: "2110320991",
      password: "senha123",
      password_confirmation: "senha123",
      role: "admin",
    )
  end

  let(:classes_data) do
    JSON.parse(File.read(Rails.root.join("spec/fixtures/classes.json")))
  end

  let(:class_members_data) do
    JSON.parse(File.read(Rails.root.join("spec/fixtures/class_members.json")))
  end

  before do
    visit root_path
    expect(page).to have_content("Bem-vindo ao CAMAAR")
    click_link "Entrar"
    expect(current_path).to eq(new_user_session_path)
    fill_in "Email ou Matrícula", with: admin_user.email
    fill_in "Senha", with: admin_user.password
    click_button "Entrar"
    expect(current_path).to eq(authenticated_root_path)
    expect(page).to have_link("Gerenciamento")
    click_link "Gerenciamento"
  end

  describe "Entrada de novos dados" do
    context "quando os arquivos são válidos" do
      scenario "importa e mescla os dados dinamicamente" do
        click_link "Importar Dados"

        expect(page).to have_content("Importar Dados")
        expect(page).to have_content("Sobrescrever dados existentes?")
        expect(page).to have_button("Enviar")
        expect(page).to have_css('input[type="file"]')

        # Anexa os arquivos de importação
        attach_file("files[]", [ Rails.root.join("spec/fixtures/classes.json"), Rails.root.join("spec/fixtures/class_members.json") ])

        # Ativa a opção de sobrescrever dados existentes
        check("Sobrescrever dados existentes?")

        click_button "Enviar"

        expect(page).to have_content("Dados importados com sucesso")

        # Combine os dados dos dois arquivos para definir os subjects esperados
        expected_subject_codes = (classes_data.map { |record| record.dig("code") } +
                                  class_members_data.map { |record| record.dig("code") }).uniq

        # Valida que os subjects importados correspondem aos códigos dos arquivos
        expect(Subject.pluck(:code)).to match_array(expected_subject_codes)

        # Para cada registro em classes.json, valida os atributos dinâmicos da turma
        classes_data.each do |record|
          subject_record = Subject.find_by(code: record.dig("code"))
          classRecord = Classroom.joins(:subject)
            .where(subjects: { code: record.dig("code") })
            .find_by(classrooms: { code: record.dig("class", "classCode") })

          expect(subject_record).to be_present
          expect(classRecord).to be_present

          expect(subject_record.name).to eq(record.dig("name")) if record.dig("name").present?
          expect(classRecord.semester).to eq(record.dig("class", "semester"))
          expect(classRecord.time).to eq(record.dig("class", "time"))
        end

        # Para cada registro em class_members.json, valida a importação de docente e enrollments
        class_members_data.each do |record|
          subject_record = Subject.find_by(code: record.dig("code"))
          expect(subject_record).to be_present

          turma = subject_record.classrooms.find { |t| t.code == record.dig("classCode") }
          expect(turma).to be_present

          if record.dig("docente")
            expect(turma.teacher).to be_present
            expect(turma.teacher.nome).to eq(record.dig("docente", "nome"))
            expect(turma.teacher.email).to eq(record.dig("docente", "email"))
          end

          if record.dig("dicente")
            # Adaptable check: just compare the count of enrolled students
            expect(Enrollment.where(classroom: turma).count).to eq(record.dig("dicente")&.size || 0)
          end
        end
      end
    end

    context "quando um arquivo inválido é enviado" do
      scenario "exibe mensagem de erro e não importa os dados" do
        click_link "Importar Dados"

        expect(page).to have_content("Importar Dados")
        expect(page).to have_content("Sobrescrever dados existentes?")
        expect(page).to have_button("Enviar")

        attach_file("files[]", Rails.root.join("spec/fixtures/wrongFile"))
        click_button "Enviar"

        expect(page).to have_content("❌ Erro de processamento.")
        expect(Subject.count).to eq(0)
      end
    end
  end
end
