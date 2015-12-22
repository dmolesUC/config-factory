module Factory
  module Factory
    class Environment

      attr_reader :name

      def initialize(name:, hash:)
        self.name = name
        @configs = deep_symbolize_keys(hash)
      end

      def config_for(key)
        @configs[key]
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment name must be a symbol' unless v && v.is_a?(Symbol)
        @name = v
      end

      def deep_symbolize_keys(val)
        return val unless val.is_a?(Hash)
        val.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, deep_symbolize_keys(v)]
        end.to_h
      end

    end
  end
end
