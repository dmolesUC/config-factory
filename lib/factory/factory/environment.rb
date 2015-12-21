module Factory
  module Factory
    class Environment

      attr_reader :name
      attr_reader :factories

      def initialize(name:, hash:)
        self.name = name
        @factories = factories_from(hash)
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment must have a name' unless v && !v.empty?
        @name = v
      end

      def factories_from(hash)
        hash.map do |k, v|
          key_symbol = to_symbol(k)
          factory_class = Factory.factory_for(key_symbol)
          factory = factory_class.new(v)
          [key_symbol, factory]
        end.to_h
      end

      def to_symbol(k)
        return k if k.is_a?(Symbol)
        return k.to_sym if k.is_a?(String)
        fail "Can't construct key symbol from #{k.class} #{k}"
      end
    end
  end
end
