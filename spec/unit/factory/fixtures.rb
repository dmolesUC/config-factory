require 'factory/factory'

# SourceConfig

class SourceConfig
  attr_reader :config_hash
  def initialize(config_hash)
    @config_hash = config_hash
  end
end

class OAISourceConfig < SourceConfig
end

class ResyncSourceConfig < SourceConfig
end

class SourceConfigFactory
  include Factory::Factory

  with protocol: 'OAI', builds: OAISourceConfig
  # with protocol: 'Resync', builds: ResyncSourceConfig
  with 'Resync', builds: ResyncSourceConfig
end

# IndexConfig

class IndexConfig
end

class SolrConfig < IndexConfig
end

class IndexConfigFactory
  include Factory::Factory

  with adapter: :solr, builds: SolrConfig
end
