module Factory
  module Factory
    class Environment

      attr_reader :name

      def initialize(name, hash)
        @name = name
      end
    end
  end
end
