require 'spec_helper'
require_relative 'fixtures'

module Factory
  module Factory

    describe AbstractFactory do
      describe '#switch' do
        it 'sets the switch symbol' do
          expect(SourceConfigFactory.switch_symbol).to eq(:protocol)
        end
        it 'defines the subclass registration method' do
          { OAI: OAISourceConfig, Resync: ResyncSourceConfig }.each do |k, v|
            expect(SourceConfigFactory.product_for(k)).to eq(v)
          end
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
