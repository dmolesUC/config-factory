module Factory
  module Factory

    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory

      attr_reader :root_symbol
      attr_reader :key_symbol

      def root(sym)
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
