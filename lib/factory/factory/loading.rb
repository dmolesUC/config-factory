require 'yaml'
require_relative 'environments'

module Factory
  module Factory
    DEFAULT_ENVIRONMENT = Environments::DEVELOPMENT

    def self.load_file(path)
      hash = YAML.load_file(path)
      if Environments::STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k) }
        hash.map { |k, v| [k, Environment.new(v)] }.to_h
      else
        Environment.new(hash)
      end
    end
  end
end
