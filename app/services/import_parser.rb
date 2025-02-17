# app/services/import_parser.rb

# Responsável pela análise e validação de arquivos durante o processo de importação.
#
# Este módulo contém métodos para analisar arquivos JSON específicos,
# como "class_members.json" e "classes.json", garantindo que os arquivos
# sejam válidos e formatados corretamente antes de serem processados.
module ImportParser
  # Analisa e valida arquivos JSON fornecidos.
  #
  # Este método recebe uma lista de arquivos, valida seus nomes e, se válidos,
  # faz o parse do conteúdo JSON para um hash de dados.
  #
  # @param files [Array<ActionDispatch::Http::UploadedFile>] A lista de arquivos a serem analisados.
  # @return [Array<Hash, Hash>] Um array contendo dois hashes com os dados de "class_members.json" e "classes.json".
  # @raise [JSON::ParserError] Levanta um erro caso o nome do arquivo não seja reconhecido.
  #
  # Exemplo:
  #   parse_files([file1, file2])
  def self.parse_files(files)
    data = {}

    files.each do |file|
      filename = file.original_filename
      if valid_filename?(filename)
        data[filename] = parse_json(file)
      else
        raise JSON::ParserError, "Unrecognized file: #{filename}"
      end
    end

    [ data["class_members.json"], data["classes.json"] ]
  end

  # Analisa o conteúdo JSON de um arquivo.
  #
  # Este método lê o conteúdo do arquivo e o converte para um objeto Ruby usando o método `JSON.parse`.
  #
  # @param file [ActionDispatch::Http::UploadedFile] O arquivo a ser analisado.
  # @return [Hash] O conteúdo JSON do arquivo convertido para um hash Ruby.
  #
  # Exemplo:
  #   parse_json(file)
  def self.parse_json(file)
    JSON.parse(file.read)
  end

  # Valida o nome do arquivo para garantir que seja um dos arquivos reconhecidos.
  #
  # Este método verifica se o nome do arquivo corresponde a "class_members.json" ou "classes.json".
  #
  # @param name [String] O nome do arquivo a ser validado.
  # @return [Boolean] Retorna true se o nome do arquivo for válido, caso contrário, retorna false.
  #
  # Exemplo:
  #   valid_filename?("class_members.json")
  def self.valid_filename?(name)
    %w[class_members.json classes.json].include?(name)
  end
end
