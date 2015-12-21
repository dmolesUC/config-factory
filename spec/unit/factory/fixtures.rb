require 'factory/factory'

# DBConfig

class DBConfigFactory
  include Factory::Factory

  key :db
end

# SourceConfig

class SourceConfig
end

class SourceConfigFactory
  include Factory::Factory

  builds SourceConfig
  key :source
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
  key :index
  switch :adapter
end

class SolrConfig < IndexConfig
end
