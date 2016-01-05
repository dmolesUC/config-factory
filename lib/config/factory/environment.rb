module Config
  module Factory
    class Environment

      attr_reader :name

      def initialize(name:, configs:)
        self.name = name
        @configs = configs
      end

      def args_for(config_name)
        config_name = config_name.to_s unless config_name.is_a?(String)
        @configs[config_name]
      end

      def self.load_file(path)
        hash = YAML.load_file(path)
        load_hash(hash)
      end

      def self.load_hash(hash)
        Environment.new(name: Environments::DEFAULT_ENVIRONMENT, configs: hash)
      end

      private

      def name=(v)
        fail ArgumentError, 'Environment name must be a symbol' unless v && v.is_a?(Symbol)
        @name = v
      end

    end
  end
end
