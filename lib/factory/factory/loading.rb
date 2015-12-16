require 'yaml'
require_relative 'environment'
require_relative 'environments'

module Factory
  module Factory
    DEFAULT_ENVIRONMENT = Environments::PRODUCTION

    def self.load_file(path)
      hash = YAML.load_file(path)
      if Environments::STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k) }
        hash.map { |k, v| [k, Environment.new(k, v)] }.to_h
      else
        Environment.new(DEFAULT_ENVIRONMENT, hash)
      end
    end
  end
end
