# app/repositories/subject_repository.rb

# Responsável por gerenciar a criação e a busca de disciplinas.
# A classe mantém uma lista interna de disciplinas e permite
# a inicialização ou atualização de registros de disciplinas
# a partir de um código e nome fornecido.
class SubjectRepository
  # Inicializa o repositório de disciplinas com uma lista vazia.
  #
  # @return [SubjectRepository] Uma instância do repositório de disciplinas.
  #
  # Exemplo:
  #   SubjectRepository.new
  def initialize
    @subjects = []
  end

  # Busca uma disciplina existente ou cria uma nova, se não encontrada.
  #
  # Este método localiza uma disciplina pelo código e, se encontrada,
  # atualiza o nome (se necessário). Caso a disciplina não exista, uma
  # nova instância será criada e adicionada à lista de disciplinas.
  #
  # @param code [String] O código da disciplina.
  # @param name [String, nil] O nome da disciplina (opcional).
  # @return [ImportSubject] A disciplina encontrada ou a nova instância criada.
  #
  # Exemplo:
  #   subject_repo.find_or_initialize("CS101", "Introdução à Programação")
  def find_or_initialize(code, name = nil)
    existing = @subjects.find { |s| s.code == code }
    existing ? update_existing(existing, name) : create_new(code, name)
  end

  # Retorna todas as disciplinas armazenadas no repositório.
  #
  # @return [Array<ImportSubject>] A lista de todas as disciplinas.
  #
  # Exemplo:
  #   subject_repo.all
  def all = @subjects

  private

  # Atualiza o nome de uma disciplina existente se o novo nome for válido.
  #
  # @param subject [ImportSubject] A disciplina a ser atualizada.
  # @param new_name [String] O novo nome da disciplina.
  # @return [ImportSubject] A disciplina atualizada.
  #
  # Exemplo:
  #   update_existing(subject, "Novo Nome")
  def update_existing(subject, new_name)
    subject.name = new_name if valid_name_update?(new_name)
    subject
  end

  # Cria uma nova disciplina e adiciona ao repositório.
  #
  # @param code [String] O código da nova disciplina.
  # @param name [String] O nome da nova disciplina.
  # @return [ImportSubject] A nova disciplina criada.
  #
  # Exemplo:
  #   create_new("CS102", "Estruturas de Dados")
  def create_new(code, name)
    ImportSubject.new.tap do |s|
      s.code = code
      s.name = name.presence || ""
      @subjects << s
    end
  end

  # Verifica se o novo nome da disciplina é válido para atualização.
  #
  # @param name [String] O nome a ser validado.
  # @return [Boolean] Retorna true se o nome for válido (não vazio), caso contrário, retorna false.
  #
  # Exemplo:
  #   valid_name_update?("Algoritmos Avançados")
  def valid_name_update?(name) = name.present? && !name.empty?
end
