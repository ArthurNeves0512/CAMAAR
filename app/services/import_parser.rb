module ImportParser
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

  def self.parse_json(file)
    JSON.parse(file.read)
  end

  def self.valid_filename?(name)
    %w[class_members.json classes.json].include?(name)
  end
end
