module Factory
  module Factory

    attr_reader :config_hash

    def initialize(config_hash)
      @config_hash = config_hash
    end

    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory
      attr_reader :build_product
      attr_reader :switch_symbol

      def builds(product_class)
        @build_product = product_class
      end

      def switch(sym)
        @switch_symbol = sym
        factory_class = self
        build_product.define_singleton_method(sym) do |val|
          factory_class.register_product(val, self)
        end
      end

      def register_product(switch_symbol, product_class)
        fail ArgumentError, "Product #{product_registry[switch]} already registered for switch symbol '#{switch_symbol}'" if product_registry.key?(switch_symbol)
        product_registry[switch_symbol] = product_class
      end

      def product_for(switch_symbol)
        product_registry[switch_symbol]
      end

      private

      def product_registry
        @product_registry ||= {}
      end
    end
  end
end
