# frozen_string_literal: true

module Config
  module Factory
    class Environment

      attr_reader :name
      attr_reader :configs

      def initialize(name:, configs:)
        self.name = name
        self.configs = configs
      end

      def args_for(config_name)
        config_name = config_name.to_s unless config_name.is_a?(String)
        @configs[config_name]
      end

      def self.load_file(path)
        hash = YAML.load_file(path)
        raise IOError, "Unable to load YAML file #{path}" unless hash && hash.is_a?(Hash)
        load_hash(hash)
      end

      def self.load_hash(hash)
        Environment.new(name: Environments::DEFAULT_ENVIRONMENT, configs: hash)
      end

      def to_s
        "#{self.class}: name = #{@name}, configs = #{@configs})"
      end

      private

      def name=(v)
        raise ArgumentError, "Environment name #{v} must be a symbol" unless v && v.is_a?(Symbol)
        @name = v
      end

      def configs=(v)
        raise ArgumentError, "Environment configs #{v} must be a hash" unless v && v.is_a?(Hash)
        @configs = v
      end

    end
  end
end
