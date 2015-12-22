require 'yaml'
require_relative 'environment'
require_relative 'environments'

module Factory
  module Factory
    def self.load_file(path)
      hash = YAML.load_file(path)
      if Environments::STANDARD_ENVIRONMENTS.any? { |k| hash.key?(k.to_s) }
        hash.map do |k, v|
          k2 = k.to_sym
          [k2, Environment.new(name: k2, hash: v)]
        end.to_h
      else
        Environment.new(name: Environments::DEFAULT_ENVIRONMENT, hash: hash)
      end
    end
  end
end
