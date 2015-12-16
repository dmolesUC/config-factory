require 'yaml'
require_relative 'environments'

module Factory
  module Factory
    DEFAULT_ENVIRONMENT = Environments::DEVELOPMENT

    def self.load_file(path)
      hash = YAML.load_file(path)
      if Environments::STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k) }
        hash
      else
        { DEFAULT_ENVIRONMENT: hash }
      end
    end
  end
end
