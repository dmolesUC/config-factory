module Config
  module Factory
    def self.included(base)
      base.extend(AbstractFactory)
    end

    module AbstractFactory
      attr_reader :product_key

      def key(k)
        @product_key = k
        registry = products_by_key
        define_singleton_method(k) do |v|
          registry[v] = self
        end
      end

      def self.extended(mod)
        registry = products_by_filter
        mod.define_singleton_method(:can_build) do |&block|
          registry[self] = block
        end
        mod.define_singleton_method(:products_by_filter) { registry }
      end

      def self.can_build(&block)
        @product_filter = block
        products_by_filter[self] = block
      end

      def for_environment(env, config_name)
        arg_hash = env.args_for(config_name)
        fail ArgumentError, "no #{self} arguments found for config #{config_name} in environment #{env}" unless arg_hash
        build_from(arg_hash)
      end

      def from_file(path, config_name)
        env = Environment.load_file(path)
        for_environment(env, config_name)
      end

      def build_from(arg_hash)
        fail ArgumentError, "nil argument hash passed to #{self}.build_from" unless arg_hash
        args = deep_symbolize_keys(arg_hash)
        product_class = find_product_class(args)
        product_class.new(args)
      end

      private

      def find_product_class(args)
        pk = product_key
        return product_for_key(pk, args) if pk
        products_by_filter.each_pair do |product, filter|
          return product if filter.call(args)
        end
        self
      end

      def product_for_key(pk, args)
        fail ArgumentError, "product key #{pk} not found in argument hash #{args}" unless args.key?(pk)
        key_value = args.delete(pk)
        product_class = products_by_key[key_value]
        fail ArgumentError, "No #{name} product class found for #{pk}: #{key_value}" unless product_class
        product_class
      end

      def deep_symbolize_keys(val)
        return val unless val.is_a?(Hash)
        val.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, deep_symbolize_keys(v)]
        end.to_h
      end

      def products_by_key
        @products_by_key ||= {}
      end

      def self.products_by_filter
        @products_by_filter ||= {}
      end
    end
  end
end
