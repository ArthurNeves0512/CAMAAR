class ImportDepartment
  attr_accessor :name

  def initialize(name = "Não definido")
    @name = name
  end
end

class ImportUser
  attr_accessor :name, :email, :password, :role, :matricula,
                :highest_degree, :active_degree, :department

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

class ImportEnrollment
  attr_accessor :user, :classroom

  def initialize
    @user = ImportUser.new
    @classroom = ImportClass.new
  end
end

class ImportClass
  attr_accessor :class_code, :semester, :time, :docente, :alunos

  def initialize
    @class_code = ""
    @semester = ""
    @time = ""
    @docente = ImportUser.new
    @alunos = []
  end

  def add_alunos(enrollment)
    @alunos << enrollment
  end
end

class ImportSubject
  attr_accessor :name, :code, :department, :turmas

  def initialize
    @name = ""
    @code = ""
    @department = ImportDepartment.new
    @turmas = []
  end

  def add_turma(turma)
    @turmas << turma
  end
end
