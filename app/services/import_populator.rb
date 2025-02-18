# Módulo responsável por popular dados no sistema durante o processo de importação.
module ImportPopulator
  # Popula o sistema com os dados fornecidos para os assuntos.
  # Para cada assunto, cria uma instância de SubjectProcessor para processá-lo.
  #
  # @param subjects [Array] Lista de assuntos a serem processados.
  # @param overwrite [Boolean] Indica se os dados existentes devem ser sobrescritos.
  def self.populate(subjects, overwrite)
    subjects.each { |subject| SubjectProcessor.new(subject, overwrite).process }
  end
end
