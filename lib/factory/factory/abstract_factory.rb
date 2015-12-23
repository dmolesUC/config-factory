module Factory
  module Factory

    attr_reader :arg_hash

    def initialize(arg_hash)
      @arg_hash = arg_hash
    end

    def build
      args = deep_symbolize_keys(arg_hash)
      self.class.build_from(args)
    end

    def self.included(base)
      base.extend(AbstractFactory)
    end

    private

    def deep_symbolize_keys(val)
      return val unless val.is_a?(Hash)
      val.map do |k, v|
        [k.respond_to?(:to_sym) ? k.to_sym : k, deep_symbolize_keys(v)]
      end.to_h
    end

    module AbstractFactory
      # attr_reader :switch_symbol

      def with(*args)
        if args.length == 1
          opts = args[0]
          k, v = opts.first
          register(k, v, opts[:builds])
        else
          k = product_registry.keys.last
          register(k, args[0], args[1][:builds])
        end
      end

      def build_from(args)
        k, product = args.lazy.map { |k, v| [k, product_for(k, v)] }.find { |r| r }
        product_args = args.select { |k2, _v2| k2 != k }
        product.new(product_args)
      end

      private

      def register(k, v, product_class)
        product_registry[k] ||= {}
        product_registry[k][v] = product_class
      end

      def product_registry
        @product_registry ||= {}
      end

      def product_keys
        product_registry.keys
      end

      def product_for(k, v)
        (products = product_registry[k]) && products[v]
      end

    end
  end
end
