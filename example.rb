#!/usr/bin/env ruby

require 'config/factory'
include Config::Factory

# Configuration classes

class SourceConfig
  include Config::Factory
  key :protocol
end

class OAISourceConfig < SourceConfig
  protocol 'OAI'

  def initialize(oai_base_url:, metadata_prefix:, set: nil, seconds_granularity: false)
    @oai_base_url = oai_base_url
    @metadata_prefix = metadata_prefix
    @set = set
    @seconds_granularity = seconds_granularity
  end
end

class ResyncSourceConfig < SourceConfig
  protocol 'Resync'

  def initialize(capability_list_url:)
    @capability_list_url = capability_list_url
  end
end

# Single-environment example

env = Environments.load_file('spec/data/single-environment.yml')
source_config = SourceConfig.for_environment(env, :source)
puts source_config
# => #<OAISourceConfig:0x007fe8d38b3990 @oai_base_url="http://oai.example.org/oai", @metadata_prefix="some_prefix", @set="some_set", @seconds_granularity=true>

# Multiple-environment example

envs = Environments.load_file('spec/data/multiple-environments.yml')
env = envs[:test]
source_config = SourceConfig.for_environment(env, :source)
puts source_config
# => #<ResyncSourceConfig:0x007fe8d48180c0 @capability_list_url="http://localhost:8888/capabilitylist.xml">
