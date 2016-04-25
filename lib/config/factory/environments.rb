require 'yaml'
require 'config/factory/environment'

module Config
  module Factory
    module Environments
      DEFAULT_ENVIRONMENT = :production
      STANDARD_ENVIRONMENTS = [:defaults, :development, :test, :stage, :staging, :production].freeze
      STANDARD_ENVIRONMENTS_NOT_FOUND = "No standard environment tags (#{STANDARD_ENVIRONMENTS.join(', ')}) found; is this really a multiple-environment configuration?"

      def self.load_file(path)
        hash = YAML.load_file(path)
        fail IOError, "Unable to load YAML file #{path}" unless hash && hash.is_a?(Hash)
        load_hash(hash)
      end

      def self.load_hash(hash)
        warn STANDARD_ENVIRONMENTS_NOT_FOUND unless STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k.to_s) }
        hash.map do |k, v|
          k2 = k.to_sym
          [k2, Environment.new(name: k2, configs: v)]
        end.to_h
      end
    end
  end
end
