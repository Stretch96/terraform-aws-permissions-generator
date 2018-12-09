module Generate
  class Helper
    def self.run!(command)
      Kernel.system(command) ||
        raise(Error, "'#{command}' failed with exit code #{$CHILD_STATUS}")
    end
  end
end
