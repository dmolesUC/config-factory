# config-factory

[![Build Status](https://travis-ci.org/dmolesUC3/config-factory.svg?branch=master)](https://travis-ci.org/dmolesUC3/config-factory)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/config-factory.svg)](https://codeclimate.com/github/dmolesUC3/config-factory)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/config-factory.svg)](http://inch-ci.org/github/dmolesUC3/config-factory)
[![Gem Version](https://img.shields.io/gem/v/config-factory.svg)](https://github.com/dmolesUC3/config-factory/releases)

A gem for creating configuration classes using the
[Abstract Factory](https://web.archive.org/web/20111109224959/http://www.informit.com/articles/article.aspx?p=1398599),
pattern, with run-time configuration provided by hashes or YAML files.

## Factory lookup patterns

### Looking up concrete factory classes based on a key value

In the basic use case, an abstract factory class defines a configuration key:

```ruby
class SourceConfig
  include Config::Factory
  key :protocol            # <- configuration key
end
```

This creates a corresponding DSL method (here `:protocol`), which implementation 
classes use to register themselves.

```ruby
class OAISourceConfig < SourceConfig
  protocol 'OAI'           # <- registers OAISourceConfig as implementation
                           #    for the "OAI" protocol
  def initialize(oai_base_url:, metadata_prefix:, set: nil, seconds_granularity: false)
    # ...
  end
end

class ResyncSourceConfig < SourceConfig
  protocol 'Resync'        # <- registers ResyncSourceConfig as implementation
                           #    for the "Resync" protocol
  def initialize(capability_list_url:)
    # ...
  end
end
```

At run time, `SourceConfig` finds the `protocol:` key in the configuration, and 
based on the value `'OAI'`, instantiates an `OAISourceConfig`, passing the remaining
arguments to the `OAISourceConfig` initializer.

```YAML
source:
  protocol: OAI           # <- indicates we want an OAISourceConfig

  # these arguments will be passed to the OAISourceConfig initializer
  oai_base_url: http://oai.example.org/oai
  metadata_prefix: some_prefix
  set: some_set
  seconds_granularity: true
```

```ruby
SourceConfig.build_from(config, :source)
# => #<OAISourceConfig:0x007fc8f14a58f0>
```

### Finding concrete factory classes based on an argument filter

In some cases (e.g., compatibility with existing configuration files), it may
be necessary to have the implementation class examine the entire configuration
hash to determine whether it can support a given configuration.

```ruby
class PersistenceConfig
  include Config::Factory
  # note no configuration key given
end

class DBPersistenceConfig < PersistenceConfig
  attr_reader :connection_info

  # Applies if we find 'adapter:' in the config file
  can_build_if { |config| config.key?(:adapter) }

  def initialize(connection_info)
    @connection_info = connection_info
  end
end

class XMLPersistenceConfig < PersistenceConfig
  attr_reader :connection_info

  # Applies if we find 'path:' in the config file
  # and its value ends in '.xml'
  can_build_if do |config|
    config[:path] && config[:path].end_with?('.xml')
  end

  def initialize(connection_info)
    @connection_info = connection_info
  end
end
```

This configuration will build a `DBPersistenceConfig`:

```YAML
persistence:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
```

```ruby
PersistenceConfig.build_from(config, :persistence)
# => #<DBPersistenceConfig:0x007fc8f14c4d18>
```

Whereas this configuration will build an `XMLConfig`:

```YAML
persistence:
  path: config/persistence.xml
```

```ruby
PersistenceConfig.build_from(config, :persistence)
# => #<XMLPersistenceConfig:0x007fc8f14ed420>
```

### Instantiating implementations directly

Finally, you may have a mix of abstract and concrete factories, so that some factories
don't need any lookup and can just be instantiated directly.

```ruby
class SolrConfig
  include Config::Factory

  def initialize(url:, proxy: nil, open_timeout: 60, read_timeout: 120)
    # ...
  end
end
```

```YAML
solr:
  url: http://solr.example.org/
  proxy: http://foo:bar@proxy.example.com/
  open_timeout: 120
  read_timeout: 300
```

```ruby
SolrConfig.build_from(config, :solr)
# => #<SolrConfig:0x007fc8f1504f08>
```

<!-- ## Environments -->

---

<!--

## Example

The abstract configuration factory declares a `key`, which is used to look up the concrete
config class for a given configuration. Concrete implementations register themselves with a
DSL method named after the `key` value.

In the example below, the `SourceConfig` abstract factory declares the key `:protocol`; the
concrete classes `OAISourceConfig` and `ResyncSourceConfig` register themselves with
`protocol: 'OAI'` and `protocol: 'Resync'`, respectively. `SourceConfig.for_environment()`
will then look for a `protocol:` line in the configuration file to determine which
registered concrete class to instantiate.


### Single-environment example

Configuration file:


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

-->
