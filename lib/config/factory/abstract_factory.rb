module Config
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

      def for_environment(env, key)
        arg_hash = env.args_for(key)
        build_from(arg_hash)
      end

      def build_from(arg_hash)
        args = deep_symbolize_keys(arg_hash)
        key_value = args.delete(product_key)
        product_class = products[key_value]
        fail ArgumentError, "No #{name} product class found for #{product_key}: #{key_value}" unless product_class
        product_class.new(args)
      end

      private

      def deep_symbolize_keys(val)
        return val unless val.is_a?(Hash)
        val.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, deep_symbolize_keys(v)]
        end.to_h
      end

      def products
        @products ||= {}
      end
    end
  end
end
