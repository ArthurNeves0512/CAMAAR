# app/models/import_department.rb

# Representa um departamento acadêmico durante o processo de importação.
#
# A classe armazena o nome do departamento e é usada para associar
# informações de departamento a usuários, como professores e alunos.
class ImportDepartment
  attr_accessor :name

  # Inicializa um novo departamento.
  #
  # @param name [String] O nome do departamento. O valor padrão é "Não definido".
  def initialize(name = "Não definido")
    @name = name
  end
end


# app/models/import_user.rb

# Representa um usuário acadêmico (aluno ou professor) durante o processo de importação.
#
# A classe armazena as informações básicas de um usuário, incluindo
# nome, email, matrícula, formação acadêmica, curso ativo, e o departamento
# a que ele pertence, além de definir a senha padrão para novos registros de aluno.
class ImportUser
  attr_accessor :name, :email, :password, :role, :matricula,
                :highest_degree, :active_degree, :department

  # Inicializa um novo usuário.
  #
  # @return [ImportUser] Um novo objeto ImportUser com valores padrão.
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


# app/models/import_enrollment.rb

# Representa a matrícula de um usuário em uma turma.
#
# A classe vincula um usuário (aluno ou professor) a uma turma,
# criando uma inscrição em uma disciplina.
class ImportEnrollment
  attr_accessor :user, :classroom

  # Inicializa uma nova inscrição.
  #
  # @return [ImportEnrollment] Um novo objeto ImportEnrollment com objetos de usuário e turma.
  def initialize
    @user = ImportUser.new
    @classroom = ImportClass.new
  end
end


# app/models/import_class.rb

# Representa uma turma de uma disciplina durante o processo de importação.
#
# A classe armazena informações sobre a turma, incluindo código da turma,
# semestre, horário, docente (professor) e alunos.
# Também fornece métodos para adicionar alunos a uma turma.
class ImportClass
  attr_accessor :class_code, :semester, :time, :docente, :alunos

  # Inicializa uma nova turma.
  #
  # @return [ImportClass] Um novo objeto ImportClass com valores padrão.
  def initialize
    @class_code = ""
    @semester = ""
    @time = ""
    @docente = ImportUser.new
    @alunos = []
  end

  # Adiciona um aluno à turma.
  #
  # @param enrollment [ImportEnrollment] A matrícula do aluno a ser adicionada à turma.
  # @return [void] Este método não retorna nenhum valor.
  def add_alunos(enrollment)
    @alunos << enrollment
  end
end


# app/models/import_subject.rb

# Representa uma disciplina acadêmica durante o processo de importação.
#
# A classe armazena informações sobre a disciplina, incluindo o nome, código,
# departamento e turmas associadas a ela. Também fornece um método para adicionar turmas à disciplina.
class ImportSubject
  attr_accessor :name, :code, :department, :turmas

  # Inicializa uma nova disciplina.
  #
  # @return [ImportSubject] Um novo objeto ImportSubject com valores padrão.
  def initialize
    @name = ""
    @code = ""
    @department = ImportDepartment.new
    @turmas = []
  end

  # Adiciona uma turma à disciplina.
  #
  # @param turma [ImportClass] A turma a ser adicionada à disciplina.
  # @return [void] Este método não retorna nenhum valor.
  def add_turma(turma)
    @turmas << turma
  end
end
