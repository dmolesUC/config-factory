module Factory
  module Factory
    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory
      attr_reader :product_key

      def key(k)
        @product_key = k
        registry = products
        define_singleton_method(k) do |v|
          registry[v] = self
        end
      end

      def build_from(arg_hash)
        args = deep_symbolize_keys(arg_hash)
        key_value = args.delete(product_key)
        product_class = products[key_value]
        product_class.new(args)
      end

      private

      def deep_symbolize_keys(val)
        return val unless val.is_a?(Hash)
        val.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, deep_symbolize_keys(v)]
        end.to_h
      end

      def product_for(v)
        products[v]
      end

      def products
        @products ||= {}
      end
    end
  end
end
