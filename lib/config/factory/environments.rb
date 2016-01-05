require 'yaml'
require_relative 'environment'

module Config
  module Factory
    module Environments
      DEFAULT_ENVIRONMENT = :production
      STANDARD_ENVIRONMENTS = [:defaults, :development, :test, :stage, :staging, :production].freeze

      def self.load_file(path)
        hash = YAML.load_file(path)
        load_hash(hash)
      end

      # TODO: separate array and single-environment loading
      def self.load_hash(hash)
        if Environments::STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k.to_s) }
          hash.map do |k, v|
            k2 = k.to_sym
            [k2, Environment.new(name: k2, configs: v)]
          end.to_h
        else
          Environment.new(name: Environments::DEFAULT_ENVIRONMENT, configs: hash)
        end
      end
    end
  end
end
