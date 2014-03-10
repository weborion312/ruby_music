module WebJam
  module Spawn
    def self.run(cmd, arguments = "", local_options = {})
      Cocaine::CommandLine.new(cmd, arguments, local_options).run
    end
  end
end
