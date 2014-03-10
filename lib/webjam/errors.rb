module WebJam
  class Error < StandardError; end

  module Errors
    class CommandNotFoundError < WebJam::Error; end
  end
end
