# Representa o departamento de um usuário importado.
class ImportDepartment
  attr_accessor :name

  # Inicializa um novo departamento com nome opcional.
  #
  # @param name [String] O nome do departamento (padrão: "Não definido").
  def initialize(name = "Não definido")
    @name = name
  end
end

# Representa um usuário importado (professor ou aluno).
class ImportUser
  attr_accessor :name, :email, :password, :role, :matricula,
                :highest_degree, :active_degree, :department

  # Inicializa um novo usuário com valores padrão.
  #
  # @param name [String] O nome do usuário.
  # @param email [String] O email do usuário.
  # @param password [String] A senha do usuário (padrão: "alunopassword").
  # @param role [Integer] O papel do usuário (0 por padrão).
  # @param matricula [String] O número de matrícula do usuário.
  # @param highest_degree [String] O grau acadêmico mais alto do usuário.
  # @param active_degree [String] O grau acadêmico ativo do usuário.
  # @param department [ImportDepartment] O departamento do usuário.
  def initialize
    @name = ""
    @email = ""
    @password = "alunopassword"
    @role = 0
    @matricula = ""
    @highest_degree = ""
    @active_degree = ""
    @department = ImportDepartment.new
  end
end

# Representa uma matrícula importada de um usuário em uma turma.
class ImportEnrollment
  attr_accessor :user, :classroom

  # Inicializa uma nova matrícula com um usuário e uma turma.
  #
  # @param user [ImportUser] O usuário que está sendo matriculado.
  # @param classroom [ImportClass] A turma na qual o usuário está matriculado.
  def initialize
    @user = ImportUser.new
    @classroom = ImportClass.new
  end
end

# Representa uma turma importada, com código, semestre, horário, docente e alunos.
class ImportClass
  attr_accessor :class_code, :semester, :time, :docente, :alunos

  # Inicializa uma nova turma com valores padrão.
  #
  # @param class_code [String] O código da turma.
  # @param semester [String] O semestre da turma.
  # @param time [String] O horário da turma.
  # @param docente [ImportUser] O docente da turma.
  # @param alunos [Array] Lista de alunos matriculados na turma.
  def initialize
    @class_code = ""
    @semester = ""
    @time = ""
    @docente = ImportUser.new
    @alunos = []
  end

  # Adiciona um aluno à turma.
  #
  # @param enrollment [ImportEnrollment] A matrícula a ser adicionada à turma.
  # @return [void] Adiciona o aluno à lista de alunos da turma.
  def add_alunos(enrollment)
    @alunos << enrollment
  end
end

# Representa uma disciplina importada, com nome, código, departamento e turmas.
class ImportSubject
  attr_accessor :name, :code, :department, :turmas

  # Inicializa uma nova disciplina com valores padrão.
  #
  # @param name [String] O nome da disciplina.
  # @param code [String] O código da disciplina.
  # @param department [ImportDepartment] O departamento da disciplina.
  # @param turmas [Array] Lista de turmas associadas à disciplina.
  def initialize
    @name = ""
    @code = ""
    @department = ImportDepartment.new
    @turmas = []
  end

  # Adiciona uma turma à disciplina.
  #
  # @param turma [ImportClass] A turma a ser adicionada à disciplina.
  # @return [void] Adiciona a turma à lista de turmas da disciplina.
  def add_turma(turma)
    @turmas << turma
  end
end
