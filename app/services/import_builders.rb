# Módulo responsável pela construção e modificação de estruturas de dados de importação para registros acadêmicos durante o processo de importação.
module ImportBuilders
  module_function

  # Constrói uma instância de ImportClass a partir de dados estruturados.
  #
  # @param data [Hash] Dados estruturados que contêm as informações sobre a turma.
  # @return [ImportClass] Instância de ImportClass preenchida com os dados extraídos.
  def build_class(data)
    ImportClass.new.tap do |import_class|
      import_class.class_code = dig_value(data, %w[classCode class.classCode])
      import_class.semester = dig_value(data, %w[semester class.semester])
      import_class.time = dig_value(data, %w[time class.time])
    end
  end

  # Cria uma representação de um professor para importação.
  #
  # @param data [Hash] Dados de entrada contendo as informações do professor.
  # @return [ImportUser] Instância de ImportUser representando o professor, com o papel de docente e departamento.
  def build_teacher(data)
    build_base_user(data).tap do |user|
      user.role = :teacher
      user.department = ImportDepartment.new(data["departamento"])
    end
  end

  # Cria uma representação de um aluno para importação.
  #
  # @param data [Hash] Dados de entrada contendo as informações do aluno.
  # @return [ImportUser] Instância de ImportUser representando o aluno, com o curso ativo.
  def build_student(data)
    build_base_user(data).tap do |user|
      user.active_degree = data["curso"]
    end
  end

  # Atualiza uma turma existente ou adiciona uma nova turma ao assunto.
  #
  # @param subject [Subject] O assunto ao qual a turma será associada.
  # @param turma [Turma] A turma a ser adicionada ou atualizada.
  # @return [void] Atualiza ou adiciona a turma ao assunto.
  def update_or_add_turma(subject, turma)
    existing_turma = find_existing_turma(subject, turma.class_code)

    if existing_turma
      update_existing_turma(existing_turma, turma)
    else
      subject.add_turma(turma)
    end
  end

  private_class_method

  # Método auxiliar para acessar dados aninhados de um hash.
  #
  # @param data [Hash] O hash contendo os dados.
  # @param keys [Array<String>] A lista de chaves para acessar os valores no hash.
  # @return [Object, nil] O valor encontrado ou nil se não houver valor.
  def dig_value(data, keys)
    keys.each do |key|
      path = key.split(".")
      value = data.dig(*path)
      return value if value.present?
    end
    nil
  end

  # Constrói uma instância base de usuário a partir de dados fornecidos.
  #
  # @param data [Hash] Dados de entrada com informações do usuário.
  # @return [ImportUser] Instância de ImportUser preenchida com os dados do usuário.
  def build_base_user(data)
    ImportUser.new.tap do |user|
      user.name = data["nome"]
      user.email = data["email"]
      user.matricula = data["matricula"] || data["usuario"]
      user.highest_degree = data["formacao"]
    end
  end

  # Busca uma turma existente no assunto com base no código da turma.
  #
  # @param subject [Subject] O assunto onde a turma será procurada.
  # @param class_code [String] O código da turma.
  # @return [Turma, nil] A turma encontrada ou nil caso não seja encontrada.
  def find_existing_turma(subject, class_code)
    subject.turmas.find { |turma| turma.class_code == class_code }
  end

  # Atualiza uma turma existente com os novos dados.
  #
  # @param existing [Turma] A turma existente a ser atualizada.
  # @param new_turma [Turma] A nova turma com dados para atualizar a turma existente.
  # @return [void] Atualiza os dados da turma existente com os dados da nova turma.
  def update_existing_turma(existing, new_turma)
    docente = new_turma.docente
    alunos = new_turma.alunos

    existing.time = new_turma.time
    existing.docente = docente if docente&.name.present?

    return if alunos.empty?
    existing.alunos = alunos
  end
end
