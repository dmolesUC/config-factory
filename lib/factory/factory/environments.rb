module Factory
  module Factory
    module Environments
      DEFAULT_ENVIRONMENT = :production
      STANDARD_ENVIRONMENTS = [:defaults, :development, :test, :stage, :staging, :production].freeze
    end
  end
end
