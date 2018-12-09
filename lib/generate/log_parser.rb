module Generate
  class LogParser
    def self.search_string
      'Validate Response'
    end

    def self.get_lines(log_file: 'crash.log')
      lines = []
      file = File.open(log_file, 'r')
      file.each_line do |line|
        if line.match(search_string)
          lines << line
        end
      end
      lines
    end

    def self.get_permission_values(log_file: 'crash.log')
      lines = get_lines(log_file: log_file)
      permissions = []
      lines.each do |line|
        line_words = line.split(/[\s\:]/)
        permissions << line_words[line_words.find_index('Response') + 1].gsub('/',':')
      end
      permissions
    end

  end
end
