# Responsável por processar as turmas relacionadas a uma disciplina.
class TurmaProcessor
  # Inicializa o processador com os dados de uma disciplina e a opção de sobrescrever.
  #
  # @param subject_record [ImportSubject] Registro da disciplina a ser associada às turmas.
  # @param overwrite [Boolean] Indica se as inscrições existentes devem ser sobrescritas.
  def initialize(subject_record, overwrite)
    @subject_record = subject_record
    @overwrite = overwrite
  end

  # Processa as turmas fornecidas, criando ou atualizando os registros necessários.
  #
  # @param turmas [Array<ImportClass>] Lista de turmas a serem processadas.
  def process(turmas)
    turmas.each { |turma| process_turma(turma) }
  end

  private

  # Processa uma única turma, criando ou associando os dados necessários.
  #
  # @param turma [ImportClass] A turma a ser processada.
  def process_turma(turma)
    teacher = TeacherBuilder.find_or_create(turma.docente)
    classroom = ClassroomBuilder.find_or_create(turma, teacher, @subject_record)
    EnrollmentHandler.new(classroom, @overwrite).process(turma.alunos)
  end
end
