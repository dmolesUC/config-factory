module Factory
  class Environment
    def initialize(hash)

    end
  end

  module Factory
    module Environments
      DEFAULTS = 'defaults'
      DEVELOPMENT = 'development'
      TEST = 'test'
      PRODUCTION = 'production'

      STANDARD_ENVIRONMENTS = [DEFAULTS, DEVELOPMENT, TEST, PRODUCTION].freeze
    end

  end
end
