module Factory
  module Factory
    class Environment

      attr_reader :name

      def initialize(name:, hash:)
        self.name = name
        @configs = hash.map { |k, v| [k, v] }.to_h
      end

      def config_for(key)
        @configs[key]
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment must have a name' unless v && !v.empty?
        @name = v
      end

    end
  end
end
