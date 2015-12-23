# config-factory

[![Build Status](https://travis-ci.org/dmolesUC3/config-factory.svg?branch=master)](https://travis-ci.org/dmolesUC3/config-factory)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/config-factory.svg)](https://codeclimate.com/github/dmolesUC3/config-factory)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/config-factory.svg)](http://inch-ci.org/github/dmolesUC3/config-factory)
[![Gem Version](https://img.shields.io/gem/v/config-factory.svg)](https://github.com/dmolesUC3/config-factory/releases)

A gem for creating configuration classes using the
[Abstract Factory](https://web.archive.org/web/20111109224959/http://www.informit.com/articles/article.aspx?p=1398599),
pattern, with run-time configuration provided by hashes or YAML files.

## Example

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

```
# config.yml

source:
  protocol: OAI
  oai_base_url: http://oai.example.org/oai
  metadata_prefix: some_prefix
  set: some_set
  seconds_granularity: true
```

<!-- TODO: Figure out environment/config loading sequence -->

### Multiple-environment example

```
# config.yml

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
