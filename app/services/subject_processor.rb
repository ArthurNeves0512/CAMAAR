# Responsável por processar e atualizar informações de um assunto (subject) no sistema,
# associando-o ao departamento e processando as turmas relacionadas.
class SubjectProcessor
  # Inicializa o processador de assunto.
  #
  # @param subject [ImportSubject] O assunto a ser processado.
  # @param overwrite [Boolean] Indica se os dados existentes devem ser sobrescritos.
  def initialize(subject, overwrite)
    @subject = subject
    @overwrite = overwrite
  end

  # Processa o assunto, criando ou atualizando o departamento e o registro do assunto.
  # Após a atualização do assunto, processa as turmas associadas.
  #
  # @return [nil] Retorna `nil` se não for possível atualizar o assunto.
  def process
    department = Department.find_or_create_by(name: @subject.department.name)
    subject_record = Subject.find_or_initialize_by(code: @subject.code)
    return unless update_subject(subject_record, department)

    TurmaProcessor.new(subject_record, @overwrite).process(@subject.turmas)
  end

  private

  # Atualiza o registro do assunto caso seja um novo registro.
  #
  # @param subject_record [Subject] O registro do assunto a ser atualizado.
  # @param department [Department] O departamento associado ao assunto.
  # @return [Boolean] Retorna `true` se o assunto foi atualizado ou se já existia.
  def update_subject(subject_record, department)
    return true unless subject_record.new_record?

    subject_record.update(name: @subject.name, department: department)
  end
end
