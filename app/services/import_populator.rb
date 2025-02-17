# services/import_populator.rb
module ImportPopulator
  module_function

  # Popula os dados acadêmicos no banco de dados.
  #
  # Este método percorre uma lista de disciplinas e processa cada uma delas,
  # criando ou atualizando os registros de acordo com os dados fornecidos.
  #
  # @param subjects [Array<ImportSubject>] A lista de disciplinas a serem processadas.
  # @param overwrite [Boolean] Se verdadeiro, sobrescreve as matrículas existentes.
  # @return [void] Este método não retorna nenhum valor.
  #
  # Exemplo:
  #   populate(subjects, overwrite)
  def populate(subjects, overwrite)
    subjects.each { |subject| SubjectProcessor.new(subject, overwrite).process }
  end
end
