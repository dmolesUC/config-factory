module Factory
  module Factory
    module Environments
      DEFAULTS = 'defaults'
      DEVELOPMENT = 'development'
      TEST = 'test'
      PRODUCTION = 'production'

      STANDARD_ENVIRONMENTS = [DEFAULTS, DEVELOPMENT, TEST, PRODUCTION].freeze
    end

    class Environment

    end
  end
end
