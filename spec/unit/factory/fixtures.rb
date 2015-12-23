require 'factory/factory'
require 'uri'

class SourceConfig
  include Factory::Factory

  key :protocol

  attr_reader :source_uri

  def initialize(source_url:)
    @source_uri = URI(source_url)
  end
end

class OAISourceConfig < SourceConfig
  protocol 'OAI'

  attr_reader :oai_base_url
  attr_reader :metadata_prefix
  attr_reader :set
  attr_reader :seconds_granularity

  def initialize(oai_base_url:, metadata_prefix:, set: nil, seconds_granularity: false)
    super(source_url: oai_base_url)
    @oai_base_url = source_uri
    @metadata_prefix = metadata_prefix
    @set = set
    @seconds_granularity = seconds_granularity
  end
end

class ResyncSourceConfig < SourceConfig
  attr_reader :capability_list_url

  def initialize(capability_list_url:)
    super(url: capability_list_url)
    @capability_list_url = source_uri
  end
end

# IndexConfig

class IndexConfig
  include Factory::Factory

  key :adapter

  attr_reader :uri

  def initialize(url:)
    @uri = URI(url)
  end
end

class SolrConfig < IndexConfig
  adapter 'Solr'

  attr_reader :url
  attr_reader :proxy
  attr_reader :open_timeout
  attr_reader :read_timeout

  def initialize(url:, proxy: nil, open_timeout: 60, read_timeout: 120)
    super(url: url)
    @url = uri
    @proxy = proxy
    @open_timeout = open_timeout
    @read_timeout = read_timeout
  end
end
