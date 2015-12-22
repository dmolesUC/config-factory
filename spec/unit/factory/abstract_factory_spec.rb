require 'spec_helper'
require_relative 'fixtures'

module Factory
  module Factory

    describe AbstractFactory do
      describe '#builds' do
        it 'registers the config keys and product classes' do
          { OAI: OAISourceConfig, Resync: ResyncSourceConfig }.each do |k, v|
            product_class = SourceConfigFactory.send(:product_for, :protocol, k)
            expect(product_class).to eq(v)
          end
        end
      end

      describe '#build' do
        it 'builds the correct class with the correct config' do
          config_hash = { protocol: 'OAI', oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          factory = SourceConfigFactory.new(config_hash)
          product = factory.build
          expect(product).to be_an(OAISourceConfig)
          sub_config_hash = { oai_base_url: 'http://oai.example.org/oai', metadata_prefix: 'some_prefix', set: 'some_set', seconds_granularity: true }
          expect(product.config_hash).to eq(sub_config_hash)
        end
      end
    end

    describe '#initialize' do
      it 'sets the config hash' do
        hash = { adapter: 'solr', url: 'http://example.org', proxy: 'http://proxy.example.org' }
        factory = IndexConfigFactory.new(hash)
        expect(factory.config_hash).to eq(hash)
      end
    end

  end
end
