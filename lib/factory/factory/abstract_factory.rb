module Factory
  module Factory

    class << self
      def register(root_symbol, factory_class)
        fail ArgumentError, "Factory #{registry[key]} already registered for root symbol '#{root_symbol}'" if registry.key?(root_symbol)
        registry[root_symbol] = factory_class
      end

      def factory_for(root_symbol)
        registry[root_symbol]
      end

      private

      def registry
        @registry ||= {}
      end
    end

    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory

      attr_reader :root_symbol
      attr_reader :key_symbol

      def root(sym)
        Factory.register(sym, self)
        @root_symbol = sym
      end

      def key(sym)
        reg = registry
        define_singleton_method(sym) do |val|
          puts "#{self}.#{sym}(#{val})"
          reg[val] = self
        end
        @key_symbol = sym
      end

      def subclass_for(k)
        registry[k]
      end

      private

      def registry
        @registry ||= {}
      end
    end

  end
end
