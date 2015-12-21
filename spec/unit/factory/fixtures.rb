require 'factory/factory'

# SourceConfig

class SourceConfig
end

class SourceConfigFactory
  include Factory::Factory

  builds SourceConfig
  switch :protocol
end

class OAISourceConfig < SourceConfig
  protocol :OAI
end

class ResyncSourceConfig < SourceConfig
  protocol :Resync
end

# IndexConfig

class IndexConfig
end

class IndexConfigFactory
  include Factory::Factory

  builds IndexConfig
  switch :adapter
end

class SolrConfig < IndexConfig
end
