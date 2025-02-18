# Serviço responsável pela importação de dados de membros de classe e turmas.
# Ele processa os dados recebidos, popula o repositório de assuntos e faz a importação para o sistema.
class ImportService
  # Inicializa o serviço de importação.
  #
  # @param files [Array] Arquivos a serem processados.
  # @param overwrite [Boolean] Indica se os dados existentes devem ser sobrescritos.
  def initialize(files, overwrite)
    @files = files
    @overwrite = overwrite.present?
    @subject_repo = SubjectRepository.new
  end

  # Processa os dados dos arquivos e popula o sistema com os registros.
  # Retorna `true` se o processo for bem-sucedido, `false` caso contrário.
  #
  # @return [Boolean] Indica se o processo de importação foi bem-sucedido.
  def process
    class_members_data, classes_data = ImportParser.parse_files(@files)
    return false unless valid_data?(class_members_data, classes_data)

    process_records(class_members_data, classes_data)
    ImportPopulator.populate(@subject_repo.all, @overwrite)
    true
  rescue JSON::ParserError
    false
  end

  private

  # Valida se os dados fornecidos são válidos (não são nil).
  #
  # @param data_sets [Array] Coleção de conjuntos de dados a serem validados.
  # @return [Boolean] Retorna `true` se nenhum conjunto de dados for `nil`.
  def valid_data?(*data_sets) = data_sets.none?(&:nil?)

  # Processa os registros de membros de classe e turmas.
  #
  # @param class_members [Array] Dados dos membros da classe a serem processados.
  # @param classes [Array] Dados das turmas a serem processados.
  def process_records(class_members, classes)
    class_members.each { |r| process_member_record(r) }
    classes.each { |r| process_class_record(r) }
  end

  # Processa os registros de turmas.
  #
  # @param record [Hash] Registro da turma a ser processado.
  def process_class_record(record)
    subject = @subject_repo.find_or_initialize(record["code"], record["name"])
    class_obj = ClassBuilder.build_from_record(record["class"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end

  # Processa os registros dos membros de classe.
  #
  # @param record [Hash] Registro do membro de classe a ser processado.
  def process_member_record(record)
    subject = @subject_repo.find_or_initialize(record["code"])
    class_obj = ClassBuilder.build_with_staff(record)
    ClassBuilder.add_students(class_obj, record["dicente"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end
end
