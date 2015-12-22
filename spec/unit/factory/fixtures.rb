require 'factory/factory'

# SourceConfig

class SourceConfig
end

class OAISourceConfig < SourceConfig
  attr_reader :oai_base_url
  attr_reader :metadata_prefix
  attr_reader :set
  attr_reader :seconds_granularity
  
  def initialize(oai_base_url:, metadata_prefix:, set: nil, seconds_granularity: false)
    @oai_base_url = oai_base_url
    @metadata_prefix = metadata_prefix
    @set = set
    @seconds_granularity = seconds_granularity
  end
end

class ResyncSourceConfig < SourceConfig
  attr_reader :capability_list_url
  def initialize(capability_list_url:)
    @capability_list_url = capability_list_url
  end
end

class SourceConfigFactory
  include Factory::Factory

  with protocol: 'OAI', builds: OAISourceConfig
  with 'Resync', builds: ResyncSourceConfig
end

# IndexConfig

class IndexConfig
end

class SolrConfig < IndexConfig
  attr_reader :adapter
  attr_reader :url
  attr_reader :proxy
  attr_reader :open_timeout
  attr_reader :read_timeout

  def initialize(adapter:, url:, proxy: nil, open_timeout: 60, read_timeout: 120)
    @adapter = adapter
    @url = url
    @proxy = proxy
    @open_timeout = open_timeout
    @read_timeout = read_timeout
  end
end

class IndexConfigFactory
  include Factory::Factory

  with adapter: :solr, builds: SolrConfig
end
