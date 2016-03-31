# config-factory

[![Build Status](https://travis-ci.org/dmolesUC3/config-factory.svg?branch=master)](https://travis-ci.org/dmolesUC3/config-factory)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/config-factory.svg)](https://codeclimate.com/github/dmolesUC3/config-factory)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/config-factory.svg)](http://inch-ci.org/github/dmolesUC3/config-factory)
[![Gem Version](https://img.shields.io/gem/v/config-factory.svg)](https://github.com/dmolesUC3/config-factory/releases)

A gem for creating configuration classes using the
[Abstract Factory](https://web.archive.org/web/20111109224959/http://www.informit.com/articles/article.aspx?p=1398599),
pattern, with run-time configuration provided by hashes or YAML files.

## Example

The abstract configuration factory declares a `key`, which is used to look up the concrete
config class for a given configuration. Concrete implementations register themselves with a
DSL method named after the `key` value.

In the example below, the `SourceConfig` abstract factory declares the key `:protocol`; the
concrete classes `OAISourceConfig` and `ResyncSourceConfig` register themselves with
`protocol: 'OAI'` and `protocol: 'Resync'`, respectively. `SourceConfig.for_environment()`
will then look for a `protocol:` line in the configuration file to determine which
registered concrete class to instantiate.

```ruby
class SourceConfig
  include Config::Factory
  key :protocol
end

class OAISourceConfig < SourceConfig
  protocol 'OAI'

  def initialize(oai_base_url:, metadata_prefix:, set: nil, seconds_granularity: false)
  end
end

class ResyncSourceConfig < SourceConfig
  protocol 'Resync'

  def initialize(capability_list_url:)
  end
end
```

### Single-environment example

Configuration file:

```YAML
source:
  protocol: OAI
  oai_base_url: http://oai.example.org/oai
  metadata_prefix: some_prefix
  set: some_set
  seconds_granularity: true
```

Loading:

```ruby
environment = Environment.load_file('spec/data/single-environment.yml')
# => #<Config::Factory::Environment:0x007fe8d3883240 @name=:production, @configs={"source"=>{"protocol"=>"OAI", "oai_base_url"=>"http://oai.example.org/oai", "metadata_prefix"=>"some_prefix", "set"=>"some_set", "seconds_granularity"=>true}}> 
source_config = SourceConfig.for_environment(environment, :source)
# => #<OAISourceConfig:0x007fe8d38b3990 @oai_base_url="http://oai.example.org/oai", @metadata_prefix="some_prefix", @set="some_set", @seconds_granularity=true> 
```

### Multiple-environment example

Configuration file:

```YAML
test:
  source:
    protocol: Resync
    capability_list_url: http://localhost:8888/capabilitylist.xml

production:
  source:
    protocol: OAI
    oai_base_url: http://oai.example.org/oai
    metadata_prefix: some_prefix
    set: some_set
    seconds_granularity: true
```

Loading:

```ruby
environments = Environments.load_file('spec/data/multiple_environments.yml')
# => {:test=>#<Config::Factory::Environment:0x007fe8d3863dc8 @name=:test, @configs={"source"=>{"protocol"=>"Resync", "capability_list_url"=>"http://localhost:8888/capabilitylist.xml"}}>, :production=>#<Config::Factory::Environment:0x007fe8d3863be8 @name=:production, @configs={"source"=>{"protocol"=>"OAI", "oai_base_url"=>"http://oai.example.org/oai", "metadata_prefix"=>"some_prefix", "set"=>"some_set", "seconds_granularity"=>true}}>} 
test_env = environments[:test]
# => #<Config::Factory::Environment:0x007fe8d383a400 @name=:test, @configs={"source"=>{"protocol"=>"Resync", "capability_list_url"=>"http://localhost:8888/capabilitylist.xml"}}> 
source_config = SourceConfig.for_environment(test_env, :source)
# => #<ResyncSourceConfig:0x007fe8d48180c0 @capability_list_url="http://localhost:8888/capabilitylist.xml"> 
```

## Config classes with only one implementation

`config-factory` also supports instantiating concrete configuration classes directly.
In this case, we simply don't declare a `key` for the class, and the configuration hash
will be passed directly to the initializer of the concrete class.

```ruby
class DBConfig
  include Config::Factory

  def initialize(connection_info)
    @connection_info = connection_info
  end
end
```

```YAML
test:
  db:
    adapter: sqlite3
    database: ':memory:'
    pool: 5
    timeout: 5000

production:
  db:
    adapter: mysql2
    host: mydb.example.org
    database: myapp
    username: myuser
    password: blank
    port: 3306
    encoding: utf8
```
