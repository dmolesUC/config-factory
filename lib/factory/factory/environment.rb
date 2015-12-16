module Factory
  module Factory
    class Environment

      attr_reader :name
      attr_reader :factories

      def initialize(name:, hash:)
        self.name = name
        @factories = hash
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment must have a name' unless v && !v.empty?
        @name = v
      end
    end
  end
end
