require 'spec_helper'
require_relative 'fixtures'

module Config
  module Factory
    module Environments
      describe '#load_file' do
        it 'loads a multi-environment config file' do
          envs = Environments.load_file('spec/data/multiple-environments.yml')
          expect(envs).to be_a(Hash)
          expected = [:defaults, :development, :test, :production]
          expect(envs.size).to eq(expected.size)
          expected.each do |env_name|
            env = envs[env_name]
            expect(env).to be_an(Environment)
            expect(env.name).to eq(env_name)
          end
        end

        it 'supports YAML references' do
          envs = Environments.load_file('spec/data/multiple-environments.yml')

          defaults = envs[:defaults]
          source_default = SourceConfig.for_environment(defaults, :source)
          expect(source_default).to be_an(OAISourceConfig)
          expect(source_default.source_uri).to eq(URI('http://oai.example.org/oai'))
          index_default = IndexConfig.for_environment(defaults, :index)
          expect(index_default).to be_a(SolrConfig)
          expect(index_default.uri).to eq(URI('http://solr.example.org/'))

          development = envs[:development]
          source_dev = SourceConfig.for_environment(development, :source)
          expect(source_dev).to be_an(OAISourceConfig)
          expect(source_dev.source_uri).to eq(URI('http://oai.example.org/oai'))
          persistence_dev = PersistenceConfig.for_environment(development, :db)
          expect(persistence_dev).to be_a(DBConfig)
          expect(persistence_dev.connection_info[:adapter]).to eq('mysql2')
          expect(persistence_dev.connection_info[:database]).to eq('example_dev')
          index_dev = IndexConfig.for_environment(development, :index)
          expect(index_dev).to be_a(SolrConfig)
          expect(index_dev.uri).to eq(URI('http://solr-dev.example.org/'))

          test = envs[:test]
          persistence_test = PersistenceConfig.for_environment(test, :db)
          expect(persistence_test).to be_a(DBConfig)
          expect(persistence_test.connection_info[:adapter]).to eq('sqlite3')
          source_test = SourceConfig.for_environment(test, :source)
          expect(source_test).to be_a(ResyncSourceConfig)
          expect(source_test.source_uri).to eq(URI('http://localhost:8888/capabilitylist.xml'))
          index_test = IndexConfig.for_environment(test, :index)
          expect(index_test).to be_a(SolrConfig)
          expect(index_test.uri).to eq(URI('http://localhost:8000/solr/'))

          production = envs[:production]
          source_production = SourceConfig.for_environment(production, :source)
          expect(source_production).to be_an(OAISourceConfig)
          expect(source_production.source_uri).to eq(URI('http://oai.example.org/oai'))
          index_production = IndexConfig.for_environment(production, :index)
          expect(index_production).to be_a(SolrConfig)
          expect(index_production.uri).to eq(URI('http://solr.example.org/'))
          persistence_production = PersistenceConfig.for_environment(production, :db)
          expect(persistence_production).to be_a(DBConfig)
          expect(persistence_production.connection_info[:adapter]).to eq('mysql2')
          expect(persistence_production.connection_info[:database]).to eq('example_prod')
        end

        it 'reads a standard ActiveRecord DB config' do
          envs = Environments.load_file('spec/data/db-config.yml')
          expect(envs).to be_a(Hash)
          expected = [:development, :test, :production]
          expect(envs.size).to eq(expected.size)
          expected.each do |env_name|
            env = envs[env_name]
            expect(env).to be_an(Environment)
            expect(env.name).to eq(env_name)
          end
        end
      end
    end
  end
end
