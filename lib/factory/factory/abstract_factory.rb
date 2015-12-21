module Factory
  module Factory

    attr_reader :config_hash

    def initialize(config_hash)
      @config_hash = config_hash
    end

    def build
      product_key = config_hash[switch_symbol]
      product_subclass = product_registry[product_key]
      product_subclass.new(config_hash)
    end

    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory
      attr_reader :switch_symbol

      def switch(sym, opts)
        @switch_symbol = sym
        opts.each { |k, v| register_product(k, v) }
      end

      def register_product(switch_value, product_subclass)
        fail ArgumentError, "Product #{product_registry[switch]} already registered for switch symbol '#{switch_symbol}'" if product_registry.key?(switch_symbol)
        product_registry[switch_value] = product_subclass
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
