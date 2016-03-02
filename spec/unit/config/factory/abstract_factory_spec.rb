require 'spec_helper'
require_relative 'fixtures'

module Config
  module Factory
    describe AbstractFactory do
      describe '#build_from' do
        it 'builds the correct class with the correct config' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          product = SourceConfig.build_from(config_hash)
          expect(product).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(product.send(k)).to eq(v)
          end
        end

        it 'raises a sensible exception if no product found for the key' do
          config_hash = { protocol: 'Elvis' }
          expect { SourceConfig.build_from(config_hash) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end
      end

      describe '#for_environment' do
        it 'builds the correct class with the correct config' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }

          product = SourceConfig.for_environment(env, :source)
          expect(product).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(product.send(k)).to eq(v)
          end
        end

        it 'raises a sensible exception if no product found for the key' do
          config_hash = { protocol: 'Elvis' }
          env = instance_double(Environment)
          expect(env).to receive(:args_for).with(:source) { config_hash }
          expect { SourceConfig.for_environment(env, :source) }.to raise_error(ArgumentError, /SourceConfig.*protocol.*Elvis/)
        end
      end

      describe '#from_file' do
        it 'builds the correct class with the correct config' do
          product = SourceConfig.from_file('spec/data/single-environment.yml', :source)
          expect(product).to be_an(OAISourceConfig)
          args = { oai_base_url: URI('http://oai.example.org/oai'), metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          args.each do |k, v|
            expect(product.send(k)).to eq(v)
          end
        end
      end
    end
  end
end
