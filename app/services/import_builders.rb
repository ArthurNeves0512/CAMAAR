# app/services/import_builders.rb

# Responsável pela construção e modificação das estruturas de dados
# para registros acadêmicos durante o processo de importação.
#
# Este módulo fornece métodos para construir e atualizar objetos de dados acadêmicos
# como `ImportClass`, `ImportUser` e `ImportDepartment`, além de adicionar ou atualizar turmas
# para uma disciplina específica com base em dados existentes.
#
# Os métodos incluem funcionalidades para construir representações de professores
# e alunos, e atualizar ou adicionar turmas a uma disciplina com base nos dados fornecidos.

module ImportBuilders
  module_function

  # Constrói um objeto ImportClass a partir de dados estruturados.
  #
  # @param data [Hash] Os dados de entrada contendo informações sobre o registro acadêmico.
  # @return [ImportClass] Um novo objeto ImportClass populado com os dados fornecidos.
  #
  # Exemplo:
  #   build_class({ "classCode" => "CS101", "semester" => "2025-1", "time" => "10:00" })
  def build_class(data)
    ImportClass.new.tap do |import_class|
      import_class.class_code = dig_value(data, %w[classCode class.classCode])
      import_class.semester = dig_value(data, %w[semester class.semester])
      import_class.time = dig_value(data, %w[time class.time])
    end
  end

  # Cria uma representação de um professor para importação.
  #
  # @param data [Hash] Os dados de entrada contendo informações sobre o professor.
  # @return [ImportUser] Um novo objeto ImportUser com atributos de professor.
  #
  # Exemplo:
  #   build_teacher({ "nome" => "John Doe", "email" => "john.doe@example.com", "departamento" => "Ciência da Computação" })
  def build_teacher(data)
    build_base_user(data).tap do |user|
      user.role = :teacher
      user.department = ImportDepartment.new(data["departamento"])
    end
  end

  # Cria uma representação de um aluno para importação.
  #
  # @param data [Hash] Os dados de entrada contendo informações sobre o aluno.
  # @return [ImportUser] Um novo objeto ImportUser com atributos de aluno.
  #
  # Exemplo:
  #   build_student({ "nome" => "Jane Smith", "email" => "jane.smith@example.com", "curso" => "Ciência da Computação" })
  def build_student(data)
    build_base_user(data).tap do |user|
      user.active_degree = data["curso"]
    end
  end

  # Atualiza uma turma existente ou adiciona uma nova à disciplina.
  #
  # @param subject [Subject] O objeto da disciplina à qual a turma está associada.
  # @param turma [Turma] O objeto da turma a ser adicionada ou atualizada.
  # @return [void] Este método não retorna nenhum valor.
  #
  # Exemplo:
  #   update_or_add_turma(subject, turma)
  def update_or_add_turma(subject, turma)
    existing_turma = find_existing_turma(subject, turma.class_code)

    if existing_turma
      update_existing_turma(existing_turma, turma)
    else
      subject.add_turma(turma)
    end
  end

  private_class_method

  # Recupera um valor de uma estrutura de dados, buscando em várias chaves.
  #
  # @param data [Hash] A estrutura de dados a ser pesquisada.
  # @param keys [Array<String>] As chaves a serem verificadas.
  # @return [Object, nil] O valor encontrado ou nil se não encontrado.
  def dig_value(data, keys)
    keys.each do |key|
      path = key.split(".")
      value = data.dig(*path)
      return value if value.present?
    end
    nil
  end

  # Constrói um usuário básico (aluno ou professor) a partir dos dados fornecidos.
  #
  # @param data [Hash] Os dados de entrada contendo informações sobre o usuário.
  # @return [ImportUser] Um novo objeto ImportUser com os atributos básicos.
  def build_base_user(data)
    ImportUser.new.tap do |user|
      user.name = data["nome"]
      user.email = data["email"]
      user.matricula = data["matricula"] || data["usuario"]
      user.highest_degree = data["formacao"]
    end
  end

  # Encontra uma turma existente com base no código da turma.
  #
  # @param subject [Subject] A disciplina à qual a turma pertence.
  # @param class_code [String] O código da turma a ser procurado.
  # @return [Turma, nil] A turma encontrada ou nil se não houver turma com esse código.
  def find_existing_turma(subject, class_code)
    subject.turmas.find { |turma| turma.class_code == class_code }
  end

  # Atualiza uma turma existente com novos dados.
  #
  # @param existing [Turma] A turma existente a ser atualizada.
  # @param new_turma [Turma] A nova turma com dados a serem aplicados à turma existente.
  # @return [void] Este método não retorna nenhum valor.
  def update_existing_turma(existing, new_turma)
    docente = new_turma.docente
    alunos = new_turma.alunos

    existing.time = new_turma.time
    existing.docente = docente if docente&.name.present?

    return if alunos.empty?
    existing.alunos = alunos
  end
end
