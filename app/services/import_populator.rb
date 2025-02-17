# app/services/import_populator.rb

# Responsável pela população dos dados acadêmicos na base de dados a partir das estruturas de importação.
#
# Este módulo lida com o processamento de disciplinas, turmas, professores, alunos e matrículas,
# atualizando ou criando os registros correspondentes no banco de dados.
#
# O processo é dividido em etapas, como a criação ou atualização de registros de disciplinas,
# turmas, e alunos, com base nos dados importados.
module ImportPopulator
  module_function

  # Popula os dados acadêmicos no banco de dados.
  #
  # Este método percorre uma lista de disciplinas e processa cada uma delas,
  # criando ou atualizando os registros de acordo com os dados fornecidos.
  #
  # @param subjects [Array<ImportSubject>] A lista de disciplinas a serem processadas.
  # @param overwrite [Boolean] Se verdadeiro, sobrescreve as matrículas existentes.
  # @return [void] Este método não retorna nenhum valor.
  #
  # Exemplo:
  #   populate(subjects, overwrite)
  def populate(subjects, overwrite)
    subjects.each { |subject| process_subject(subject, overwrite) }
  end

  # Processa uma disciplina, criando ou atualizando seus registros no banco de dados.
  #
  # Este método encontra ou cria o departamento e o registro da disciplina, 
  # e, em seguida, processa as turmas associadas a essa disciplina.
  #
  # @param subject [ImportSubject] A disciplina a ser processada.
  # @param overwrite [Boolean] Se verdadeiro, sobrescreve as matrículas existentes.
  # @return [void] Este método não retorna nenhum valor.
  #
  # Exemplo:
  #   process_subject(subject, overwrite)
  def process_subject(subject, overwrite)
    department = Department.find_or_create_by(name: subject.department.name)
    subject_record = Subject.find_or_initialize_by(code: subject.code)
    return unless update_subject_record(subject_record, subject.name, department)

    process_subject_turmas(subject, subject_record, overwrite)
  end

  # Classe responsável pelo processamento das turmas de uma disciplina.
  class TurmaProcessor
    def initialize(subject_record, overwrite)
      @subject_record = subject_record
      @overwrite = overwrite
    end

    # Processa uma turma, criando ou atualizando seus registros de professor e alunos.
    #
    # Este método encontra ou cria o professor e a sala de aula, e em seguida
    # gerencia as matrículas dos alunos na turma.
    #
    # @param turma [ImportClass] A turma a ser processada.
    # @return [void] Este método não retorna nenhum valor.
    def process(turma)
      teacher = find_or_create_teacher(turma.docente)
      classroom = find_or_create_classroom(turma, teacher)

      handle_classroom_enrollments(classroom, turma.alunos)
    end

    private

    # Encontra ou cria um professor a partir dos dados fornecidos.
    #
    # @param teacher_data [ImportUser] Os dados do professor a ser encontrado ou criado.
    # @return [User] O usuário (professor) encontrado ou criado.
    def find_or_create_teacher(teacher_data)
      UserBuilder.find_or_create(teacher_data, :teacher)
    end

    # Encontra ou cria uma sala de aula a partir dos dados da turma e professor.
    #
    # @param turma [ImportClass] Os dados da turma.
    # @param teacher [User] O professor da turma.
    # @return [Classroom] A sala de aula criada ou encontrada.
    def find_or_create_classroom(turma, teacher)
      classroom = Classroom.find_or_initialize_by(
        code: turma.class_code,
        subject: @subject_record
      )

      ClassroomManager.update_or_create(classroom, turma, teacher)
      classroom
    end

    # Gerencia as matrículas de alunos na sala de aula.
    #
    # Se a opção `overwrite` for verdadeira, as matrículas existentes serão
    # excluídas antes de adicionar as novas matrículas.
    #
    # @param classroom [Classroom] A sala de aula a ser atualizada com as matrículas.
    # @param students [Array<ImportEnrollment>] A lista de alunos a serem matriculados.
    # @return [void] Este método não retorna nenhum valor.
    def handle_classroom_enrollments(classroom, students)
      classroom.enrollments.destroy_all if @overwrite
      students.each do |enrollment|
        student = UserBuilder.find_or_create(enrollment.user, :student)
        Enrollment.create(user: student, classroom: classroom)
      end
    end
  end

  # Módulo responsável pela criação ou atualização de usuários (alunos ou professores).
  module UserBuilder
    module_function

    # Encontra ou cria um usuário (aluno ou professor) a partir dos dados fornecidos.
    #
    # Este método verifica se o usuário já existe com base na matrícula e,
    # se não existir, cria um novo registro com os dados fornecidos.
    #
    # @param user_data [ImportUser] Os dados do usuário a ser encontrado ou criado.
    # @param role [Symbol] O papel do usuário (:student ou :teacher).
    # @return [User] O usuário encontrado ou criado.
    def find_or_create(user_data, role)
      user = User.find_or_initialize_by(matricula: user_data.matricula)
      return user unless user.new_record?

      password = user_data.password
      user.update(
        nome: user_data.name,
        role: role,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.current,
        highest_degree: user_data.highest_degree,
        active_degree: user_data.active_degree,
        email: user_data.email
      )
      user
    end
  end

  private_class_method

  # Atualiza o registro da disciplina com o nome e departamento fornecidos.
  #
  # @param record [Subject] O registro da disciplina a ser atualizado.
  # @param name [String] O nome da disciplina.
  # @param department [Department] O departamento ao qual a disciplina pertence.
  # @return [Boolean] Retorna true se o registro foi atualizado com sucesso, caso contrário, retorna false.
  def update_subject_record(record, name, department)
    return true unless record.new_record?

    record.update(name: name, department: department)
  end

  # Processa as turmas de uma disciplina, criando ou atualizando os registros de turma.
  #
  # @param subject [ImportSubject] A disciplina que contém as turmas.
  # @param subject_record [Subject] O registro da disciplina a ser associado às turmas.
  # @param overwrite [Boolean] Se verdadeiro, sobrescreve as matrículas existentes.
  # @return [void] Este método não retorna nenhum valor.
  def process_subject_turmas(subject, subject_record, overwrite)
    processor = TurmaProcessor.new(subject_record, overwrite)
    subject.turmas.each { |turma| processor.process(turma) }
  end
end
