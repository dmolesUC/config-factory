require 'factory/factory'

# SourceConfig

class SourceConfig
end

class OAISourceConfig < SourceConfig
end

class ResyncSourceConfig < SourceConfig
end

class SourceConfigFactory
  include Factory::Factory

  switch :protocol, OAI: OAISourceConfig, Resync: ResyncSourceConfig
end

# IndexConfig

class IndexConfig
end

class SolrConfig < IndexConfig
end

class IndexConfigFactory
  include Factory::Factory

  switch :adapter, solr: SolrConfig
end
