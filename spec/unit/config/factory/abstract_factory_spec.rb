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
      end
    end
  end
end
