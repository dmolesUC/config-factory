module Factory
  module Factory

    attr_reader :config_hash

    def initialize(config_hash)
      @config_hash = config_hash
    end

    def build
      build_from(config_hash)
    end

    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory
      # attr_reader :switch_symbol

      def with(*args)
        if args.length == 1
          opts = args[0]
          k, v = opts.first
          product_class = opts[:builds]
        else
          k = product_registry.keys.last
          v = args[0]
          opts = args[1]
          product_class = opts[:builds]
        end

        product_registry[k] ||= {}
        product_registry[k][v.to_s] = product_class
      end

      # def builds(sym, opts)
      #   @switch_symbol = sym
      #   opts.each { |k, v| register_product(k, v) }
      # end
      #
      # def register_product(switch_value, product_subclass)
      #   fail ArgumentError, "Product #{product_registry[switch]} already registered for switch symbol '#{switch_symbol}'" if product_registry.key?(switch_symbol)
      #   product_registry[switch_value] = product_subclass
      # end
      #
      # def product_for(switch_symbol)
      #   product_registry[switch_symbol]
      # end

      private

      def product_registry
        @product_registry ||= {}
      end

      def product_keys
        product_registry.keys
      end

      def product_for(k, v)
        products = product_registry[k] and products[v.to_s]
      end

      def build_from(config_hash)
        k, v, product = config_hash.lazy.map { |k, v| [k, v, product_for(k, v)] }.find { |r| r }
        sub_config = config_hash.select { |k2, _v2| k2 != k }
        product.new(sub_config)
      end
    end
  end
end
