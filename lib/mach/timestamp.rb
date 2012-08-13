module Mach
  class Timestamp
    class << self
      def now
        Time.now.utc.to_i
      end
    end
  end
end
