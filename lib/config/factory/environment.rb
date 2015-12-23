module Config
  module Factory
    class Environment

      attr_reader :name

      def initialize(name:, factory_configs:)
        self.name = name
        @configs = factory_configs
      end

      def args_for(factory)
        @configs[factory]
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment name must be a symbol' unless v && v.is_a?(Symbol)
        @name = v
      end

    end
  end
end
