# Service object responsável por gerenciar o processamento de matrículas de alunos em uma sala de aula.
class EnrollmentHandler
  # Inicializa o manipulador de matrículas com a sala de aula e a opção de sobrescrever matrículas existentes.
  #
  # @param classroom [Classroom] A sala de aula onde as matrículas serão processadas.
  # @param overwrite [Boolean] Flag que indica se as matrículas existentes devem ser apagadas antes de criar novas.
  def initialize(classroom, overwrite)
    @classroom = classroom
    @overwrite = overwrite
  end

  # Processa as matrículas dos alunos, com a opção de sobrescrever as matrículas existentes.
  #
  # @param students [Array<Hash>] Array de hashes contendo os dados dos alunos a serem matriculados.
  # @effect Se a opção `@overwrite` for verdadeira, as matrículas existentes são removidas antes de adicionar as novas.
  def process(students)
    clear_enrollments if @overwrite
    create_enrollments(students)
  end

  private

  # Remove todas as matrículas atuais da sala de aula.
  #
  # @effect Apaga todas as matrículas associadas à sala de aula.
  def clear_enrollments
    @classroom.enrollments.destroy_all
  end

  # Cria novas matrículas para os alunos fornecidos.
  #
  # @param students [Array<Hash>] Array de hashes contendo os dados dos alunos a serem matriculados.
  # @effect Cria novas matrículas para cada aluno na sala de aula.
  def create_enrollments(students)
    students.each do |student_data|
      student = UserBuilder.find_or_create(student_data.user, :student)
      Enrollment.create(user: student, classroom: @classroom)
    end
  end
end
