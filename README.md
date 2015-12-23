# config-factory

[![Build Status](https://travis-ci.org/dmolesUC3/factory-factory.svg?branch=master)](https://travis-ci.org/dmolesUC3/factory-factory)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/factory-factory.svg)](https://codeclimate.com/github/dmolesUC3/factory-factory)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/factory-factory.svg)](http://inch-ci.org/github/dmolesUC3/factory-factory)
[![Gem Version](https://img.shields.io/gem/v/factory-factory.svg)](https://github.com/dmolesUC3/factory-factory/releases)

A gem for creating configuration classes using the
[Abstract Factory](https://web.archive.org/web/20111109224959/http://www.informit.com/articles/article.aspx?p=1398599),
pattern, with run-time configuration provided by hashes or YAML files.

## Single-environment example

```
# config.yml

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
db:
  adapter: mysql2
  encoding: utf8
  pool: 5
  database: example_pord
  host: mysql-dev.example.org
  port: 3306
```

