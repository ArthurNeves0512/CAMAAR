# Módulo responsável pela análise e parsing de arquivos JSON durante o processo de importação.
module ImportParser
  # Analisa os arquivos fornecidos, validando seus nomes e processando os dados JSON.
  #
  # @param files [Array] Lista de arquivos a serem analisados.
  # @return [Array] Retorna um array com os dados de "class_members.json" e "classes.json".
  # @raise [JSON::ParserError] Levanta um erro caso o arquivo tenha um nome não reconhecido.
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

  # Converte o conteúdo do arquivo para um objeto JSON.
  #
  # @param file [File] O arquivo a ser convertido.
  # @return [Hash] Retorna o conteúdo JSON do arquivo como um hash.
  def self.parse_json(file)
    JSON.parse(file.read)
  end

  # Verifica se o nome do arquivo é um nome válido para os arquivos que podem ser processados.
  #
  # @param name [String] O nome do arquivo a ser verificado.
  # @return [Boolean] Retorna true se o nome do arquivo for válido, false caso contrário.
  def self.valid_filename?(name)
    %w[class_members.json classes.json].include?(name)
  end
end
