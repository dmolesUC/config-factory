# config-factory

[![Build Status](https://travis-ci.org/dmolesUC3/config-factory.svg?branch=master)](https://travis-ci.org/dmolesUC3/config-factory)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/config-factory.svg)](https://codeclimate.com/github/dmolesUC3/config-factory)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/config-factory.svg)](http://inch-ci.org/github/dmolesUC3/config-factory)
[![Gem Version](https://img.shields.io/gem/v/config-factory.svg)](https://github.com/dmolesUC3/config-factory/releases)

A gem for creating configuration classes using the
[Abstract Factory](https://web.archive.org/web/20111109224959/http://www.informit.com/articles/article.aspx?p=1398599),
pattern, with run-time configuration provided by hashes or YAML files.

- [Factory lookup patterns](#factory-lookup-patterns)
  - [Looking up concrete factory classes based on a key value](#looking-up-concrete-factory-classes-based-on-a-key-value)
  - [Finding concrete factory classes based on an argument filter](#finding-concrete-factory-classes-based-on-an-argument-filter)
  - [Instantiating implementations directly](#instantiating-implementations-directly)
- [Environments](#environments)
  - [Multiple environments](#multiple-environments)
  - [Single environment](#single-environment)

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
config = YAML.load_file('config.yml')
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
config = YAML.load_file('config.yml')
PersistenceConfig.build_from(config, :persistence)
# => #<DBPersistenceConfig:0x007fc8f14c4d18>
```

Whereas this configuration will build an `XMLConfig`:

```YAML
persistence:
  path: config/persistence.xml
```

```ruby
config = YAML.load_file('config.yml')
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
config = YAML.load_file('config.yml')
SolrConfig.build_from(config, :solr)
# => #<SolrConfig:0x007fc8f1504f08>
```

## Environments

The YAML examples above each show only the configuration for a single factory. However,
`Config::Factory` also supports a structured configuration file with configurations for
multiple factories, optionally organized into environments.

### Multiple environments

The `Environments.load_file()` method loads a multi-environment config file as a hash
of `Environment` instances.

```ruby
envs = Environments.load_file('config.yml')
# => {:defaults=>#<Environment:0x007f8e9a578818>,
#     :development=>#<Environment:0x007f8e9a578728>,
#     :test=>#<Environment:0x007f8e9a578660>,
#     :production=>#<Environment:0x007f8e9a578520>}
test = envs[:test]
# => #<Environment:0x007f8e9a578660>
```

The `AbstractFactory.for_environment()` method takes an environment instance and a 
configuration section name.

```ruby
source = SourceConfig.for_environment(test, :source)
# => #<ResyncSourceConfig:0x007f8e9a54a878>
index = IndexConfig.for_environment(test, :index)
# => #<SolrConfig:0x007f8e9a5383a8>
persistence = PersistenceConfig.for_environment(test, :persistence)
# => #<DBConfig:0x007f8e9a5019e8>
```

The configuration file for the examples above. Note that standard YAML features such
as references are supported.

```YAML
defaults: &defaults
  source:
    protocol: OAI
    oai_base_url: http://oai.example.org/oai
    metadata_prefix: some_prefix
    set: some_set
    seconds_granularity: true
  index:
    adapter: solr
    url: http://solr.example.org/
    proxy: http://foo:bar@proxy.example.com/
    open_timeout: 120
    read_timeout: 300

development:
  <<: *defaults
  persistence:
    adapter: mysql2
    encoding: utf8
    pool: 5
    database: example_dev
    host: mysql-dev.example.org
    port: 3306
  index:
    adapter: solr
    url: http://solr-dev.example.org/
    proxy: http://foo:bar@proxy.example.com/
    open_timeout: 120
    read_timeout: 300

test:
  persistence:
    adapter: sqlite3
    database: ':memory:'
    pool: 5
    timeout: 5000
  source:
    protocol: Resync
    capability_list_url: http://localhost:8888/capabilitylist.xml
  index:
    adapter: solr
    url: http://localhost:8000/solr/

production:
  <<: *defaults
  persistence:
    adapter: mysql2
    encoding: utf8
    pool: 5
    database: example_prod
    host: mysql.example.org
    port: 3306
```

The `Environments` module supports arbitrary environment names, but the standard ones
are `:defaults`, `:development`, `:test`, `:stage`, `:staging,` and `:production`. The
`Environments.load_file` method will warn if none of these are present, as this might
indicate loading a single-environment config file as multiple by mistake.

### Single environment

For a single-environment config file, use the `load_file()` method on the `Environment`
class itself (not the `Environments` module, plural):

```ruby
env = Environment.load_file('config.yml')
# => #<Environment:0x007f8e9a49b1c0>
persistence = PersistenceConfig.for_environment(env, :persistence)
# => #<DBConfig:0x007f8e9a45abe8>
source = SourceConfig.for_environment(env, :source)
# => #<OAISourceConfig:0x007f8e9a482fa8>
index = IndexConfig.for_environment(env, :index)
# => #<SolrConfig:0x007f8e9a4438a8>
```

```YAML
persistence:
  adapter: mysql2
  encoding: utf8
  pool: 5
  database: example_prod
  host: mysql-dev.example.org
  port: 3306
source:
  protocol: OAI
  oai_base_url: http://oai.example.org/oai
  metadata_prefix: some_prefix
  set: some_set
  seconds_granularity: true
index:
  adapter: solr
  url: http://solr.example.org/
  proxy: http://foo:bar@proxy.example.com/
  open_timeout: 120
  read_timeout: 300
```

By default, a single environment uses the environment name `:production`.
