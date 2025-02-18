require_relative "import_data_classes"

# Gerencia o repositório de disciplinas, permitindo
# a criação e recuperação de objetos de disciplinas
# baseados em código e nome.
class SubjectRepository
  # Inicializa um repositório vazio de disciplinas.
  #
  # @return [SubjectRepository] Uma instância de SubjectRepository.
  def initialize
    @subjects = []
  end

  # Encontra uma disciplina existente ou cria uma nova com
  # o código e nome fornecidos.
  #
  # @param code [String] O código da disciplina.
  # @param name [String, nil] O nome da disciplina.
  # @return [ImportSubject] A disciplina existente ou recém-criada.
  def find_or_initialize(code, name = nil)
    existing = @subjects.find { |s| s.code == code }
    existing ? update_existing(existing, name) : create_new(code, name)
  end

  # Retorna todas as disciplinas no repositório.
  #
  # @return [Array<ImportSubject>] Lista de todas as disciplinas.
  def all
    @subjects
  end

  private

  # Atualiza o nome de uma disciplina existente, caso o nome
  # fornecido seja válido.
  #
  # @param subject [ImportSubject] A disciplina a ser atualizada.
  # @param new_name [String] O novo nome para a disciplina.
  # @return [ImportSubject] A disciplina atualizada.
  def update_existing(subject, new_name)
    subject.name = new_name if valid_name_update?(new_name)
    subject
  end

  # Cria uma nova disciplina e a adiciona ao repositório.
  #
  # @param code [String] O código da nova disciplina.
  # @param name [String] O nome da nova disciplina.
  # @return [ImportSubject] A nova disciplina criada.
  def create_new(code, name)
    ImportSubject.new.tap do |s|
      s.code = code
      s.name = name.presence || ""
      @subjects << s
    end
  end

  # Verifica se o nome fornecido é válido para atualização.
  #
  # @param name [String] O nome a ser verificado.
  # @return [Boolean] Retorna true se o nome for válido, false caso contrário.
  def valid_name_update?(name)
    name.present? && !name.empty?
  end
end
