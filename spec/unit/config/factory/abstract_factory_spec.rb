require 'spec_helper'
require_relative 'fixtures'

module Config
  module Factory
    describe AbstractFactory do
      describe '#build_from' do
        it 'builds the correct class with the correct config' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          impl = SourceConfig.build_from(config_hash)
          expect(impl).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(impl.send(k)).to eq(v)
          end
        end

        it 'defaults to Environments::DEFAULT_ENVIRONMENT' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          impl = SourceConfig.build_from(config_hash)
          expect(impl.env_name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end

        it 'raises a sensible exception if no impl found for the key' do
          config_hash = { protocol: 'Elvis' }
          expect { SourceConfig.build_from(config_hash) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end

        it 'supports implementation factories without impl keys' do
          config_hash = {
            adapter: 'mysql2',
            encoding: 'utf8',
            pool: 5,
            database: 'example_prod',
            host: 'mysql-dev.example.org',
            port: 3306
          }
          impl = MysqlConfig.build_from(config_hash)
          expect(impl).to be_a(MysqlConfig)
          expect(impl.connection_info).to eq(config_hash)
          expect(impl.env_name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end

        it "can build a class without a declared key, so long as it's registered" do
          config_hash = {
            adapter: 'mysql2',
            encoding: 'utf8',
            pool: 5,
            database: 'example_prod',
            host: 'mysql-dev.example.org',
            port: 3306
          }
          impl = PersistenceConfig.build_from(config_hash)
          expect(impl).to be_a(DBConfig)
          expect(impl.connection_info).to eq(config_hash)
          expect(impl.env_name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end

        it 'works with section headers' do
          expected_info = {
            adapter: 'sqlite3',
            database: 'db/production.sqlite3',
            pool: 5,
            timeout: 5000
          }

          hash = YAML.load_file('spec/data/raw-section.yml')
          impl = PersistenceConfig.build_from(hash, :persistence)
          expect(impl).to be_a(DBConfig)
          expect(impl.connection_info).to eq(expected_info)
          expect(impl.env_name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end
      end

      describe '#for_environment' do
        it 'builds the correct class with the correct config' do
          env = instance_double(Environment)

          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          expect(env).to receive(:args_for).with(:source) { config_hash }

          env_name = :elvis
          expect(env).to receive(:name) { env_name }

          impl = SourceConfig.for_environment(env, :source)
          expect(impl).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(impl.send(k)).to eq(v)
          end
          expect(impl.env_name).to eq(env_name)
        end

        it 'raises a sensible exception if no impl found for the key' do
          config_hash = { protocol: 'Elvis' }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }
          expect(env).to receive(:name) { 'elvis' }
          expect { SourceConfig.for_environment(env, :source) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end

        it 'raises a sensible exception if initializer fails' do
          bad_uri = 'I am not a URI'
          config_hash = {
            protocol: 'OAI',
            oai_base_url: bad_uri,
            metadata_prefix: 'some_prefix'
          }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }
          expect(env).to receive(:name) { 'elvis' }
          expect { SourceConfig.for_environment(env, :source) }.to raise_error(ArgumentError, /OAISourceConfig.*#{bad_uri}/)
        end
      end

      describe '#from_file' do
        it 'builds the correct class with the correct config' do
          impl = SourceConfig.from_file('spec/data/single-environment.yml', :source)
          expect(impl).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(impl.send(k)).to eq(v)
          end
        end
      end
    end
  end
end
