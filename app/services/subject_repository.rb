# Responsável por gerenciar o repositório de assuntos (subjects), incluindo a busca,
# criação e atualização de registros de assuntos.
class SubjectRepository
  # Inicializa o repositório de assuntos com um array vazio.
  def initialize
    @subjects = []
  end

  # Busca um assunto existente com o código fornecido ou cria um novo caso não exista.
  #
  # @param code [String] O código do assunto.
  # @param name [String, nil] O nome do assunto. Se não fornecido, será `nil`.
  # @return [ImportSubject] O assunto encontrado ou criado.
  def find_or_initialize(code, name = nil)
    existing = @subjects.find { |s| s.code == code }
    existing ? update_existing(existing, name) : create_new(code, name)
  end

  # Retorna todos os assuntos armazenados no repositório.
  #
  # @return [Array<ImportSubject>] Lista de todos os assuntos.
  def all = @subjects

  private

  # Atualiza um assunto existente com um novo nome se o nome for válido.
  #
  # @param subject [ImportSubject] O assunto a ser atualizado.
  # @param new_name [String] O novo nome do assunto.
  # @return [ImportSubject] O assunto atualizado.
  def update_existing(subject, new_name)
    subject.name = new_name if valid_name_update?(new_name)
    subject
  end

  # Cria um novo assunto com o código e nome fornecidos.
  #
  # @param code [String] O código do assunto.
  # @param name [String] O nome do assunto.
  # @return [ImportSubject] O novo assunto criado.
  def create_new(code, name)
    ImportSubject.new.tap do |s|
      s.code = code
      s.name = name.presence || ""
      @subjects << s
    end
  end

  # Verifica se o nome fornecido é válido para atualização (não nulo ou vazio).
  #
  # @param name [String] O nome a ser verificado.
  # @return [Boolean] `true` se o nome for válido, `false` caso contrário.
  def valid_name_update?(name) = name.present? && !name.empty?
end
