module Generate
  class Logger
    require 'colorize'

    def self.error(message)
      raise("[!] #{message}".colorize(:light_red))
    end

    def self.info(message)
      Kernel.puts "[*] #{message}".colorize(:light_white)
    end

    def self.success(message)
      Kernel.puts "[*] #{message}".colorize(:light_green)
    end

    def self.warn(message)
      Kernel.puts "[*] #{message}".colorize(:light_yellow)
    end
  end
end
