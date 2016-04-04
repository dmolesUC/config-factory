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

        it 'raises a sensible exception if no impl found for the key' do
          config_hash = { protocol: 'Elvis' }
          expect { SourceConfig.build_from(config_hash) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end

        it 'supports implementation factories without impl keys' do
          config_hash = {
            adapter: 'mysql2',
            encoding: 'utf8',
            pool: 5,
            database: 'example_pord',
            host: 'mysql-dev.example.org',
            port: 3306
          }
          impl = MysqlConfig.build_from(config_hash)
          expect(impl).to be_a(MysqlConfig)
          expect(impl.connection_info).to eq(config_hash)
        end
      end

      describe '#for_environment' do
        it 'builds the correct class with the correct config' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }

          impl = SourceConfig.for_environment(env, :source)
          expect(impl).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(impl.send(k)).to eq(v)
          end
        end

        it 'raises a sensible exception if no impl found for the key' do
          config_hash = { protocol: 'Elvis' }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }
          expect { SourceConfig.for_environment(env, :source) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end

        it "can build a class without a declared key, so long as it's registered" do
          config_hash = {
            adapter: 'mysql2',
            encoding: 'utf8',
            pool: 5,
            database: 'example_pord',
            host: 'mysql-dev.example.org',
            port: 3306
          }
          impl = PersistenceConfig.build_from(config_hash)
          expect(impl).to be_a(DBConfig)
          expect(impl.connection_info).to eq(config_hash)
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
