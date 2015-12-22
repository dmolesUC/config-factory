module Factory
  module Factory
    module Environments
      DEFAULTS = 'defaults'
      DEVELOPMENT = 'development'
      TEST = 'test'
      STAGE = 'stage'
      STAGING = 'staging'
      PRODUCTION = 'production'
      STANDARD_ENVIRONMENTS = [DEFAULTS, DEVELOPMENT, TEST, STAGE, STAGING, PRODUCTION].freeze
    end
  end
end
