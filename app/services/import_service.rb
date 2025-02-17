# app/services/import_service.rb

# Serviço responsável pela coordenação e processamento de arquivos de importação
# e pela população dos dados acadêmicos no banco de dados.
#
# Este serviço integra os módulos `ImportParser`, `ImportPopulator`, `SubjectRepository`
# e `ClassBuilder`, oferecendo um fluxo completo para a importação de dados relacionados
# a disciplinas, turmas, alunos e professores, validando e processando as informações
# antes de populá-las na base de dados.
class ImportService
  # Inicializa o serviço de importação com os arquivos a serem processados e a opção de sobrescrever dados.
  #
  # @param files [Array<ActionDispatch::Http::UploadedFile>] A lista de arquivos a serem processados.
  # @param overwrite [Boolean] Se verdadeiro, sobrescreve os dados existentes durante a importação.
  # @return [ImportService] Uma instância do serviço de importação.
  #
  # Exemplo:
  #   ImportService.new(files, overwrite)
  def initialize(files, overwrite)
    @files = files
    @overwrite = overwrite.present?
    @subject_repo = SubjectRepository.new
  end

  # Processa os arquivos de importação, validando os dados e populando os registros no banco de dados.
  #
  # Este método analisa os arquivos de membros da classe e turmas, valida os dados,
  # e em seguida processa os registros e os popula no banco de dados.
  #
  # @return [Boolean] Retorna true se o processamento foi bem-sucedido, caso contrário, retorna false.
  #
  # Exemplo:
  #   import_service.process
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

  # Verifica se todos os dados fornecidos são válidos (não nulos).
  #
  # @param data_sets [Array] Um ou mais conjuntos de dados a serem validados.
  # @return [Boolean] Retorna true se todos os dados são válidos, caso contrário, retorna false.
  #
  # Exemplo:
  #   valid_data?(data_set1, data_set2)
  def valid_data?(*data_sets) = data_sets.none?(&:nil?)

  # Processa os registros das turmas e membros da classe, criando ou atualizando os registros.
  #
  # @param class_members [Array<Hash>] Os dados dos membros da classe a serem processados.
  # @param classes [Array<Hash>] Os dados das turmas a serem processadas.
  # @return [void] Este método não retorna nenhum valor.
  def process_records(class_members, classes)
    class_members.each { |r| process_member_record(r) }
    classes.each { |r| process_class_record(r) }
  end

  # Processa os registros das turmas.
  #
  # Este método encontra ou inicializa a disciplina correspondente e cria ou atualiza
  # a turma associada ao registro da turma.
  #
  # @param record [Hash] O registro da turma a ser processado.
  # @return [void] Este método não retorna nenhum valor.
  def process_class_record(record)
    subject = @subject_repo.find_or_initialize(record["code"], record["name"])
    class_obj = ClassBuilder.build_from_record(record["class"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end

  # Processa os registros dos membros da classe.
  #
  # Este método encontra ou inicializa a disciplina correspondente, constrói a turma
  # com base nos dados do membro da classe e adiciona os alunos à turma.
  #
  # @param record [Hash] O registro do membro da classe a ser processado.
  # @return [void] Este método não retorna nenhum valor.
  def process_member_record(record)
    subject = @subject_repo.find_or_initialize(record["code"])
    class_obj = ClassBuilder.build_with_staff(record)
    ClassBuilder.add_students(class_obj, record["dicente"])
    ImportBuilders.update_or_add_turma(subject, class_obj)
  end
end
