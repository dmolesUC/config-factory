require 'spec_helper'
require_relative 'fixtures'

module Factory
  module Factory
    describe Environment do

      describe '#new' do
        it 'sets the name' do
          env = Environment.new(name: 'name', hash: {})
          expect(env.name).to eq('name')
        end
        it 'requires a name' do
          expect { Environment.new(name: nil, hash: {}) }.to raise_error(ArgumentError)
        end
        it 'requires a non-empty name' do
          expect { Environment.new(name: '', hash: {}) }.to raise_error(ArgumentError)
        end
        it 'creates the factories' do
          env = Environment.new(name: 'test', hash: YAML.load_file('spec/data/single-environment.yml'))
          factories = env.factories
          expect(factories).to be_a(Hash)
          expect(factories.size).to eq(3)
          expect(factories[:db]).to be_a(DBConfigFactory)
          expect(factories[:source]).to be_a(SourceConfigFactory)
          expect(factories[:index]).to be_an(IndexConfigFactory)
        end
        it 'configures the factories' do
          env_yaml = YAML.load_file('spec/data/single-environment.yml')
          env = Environment.new(name: 'test', hash: env_yaml)
          factories = env.factories
          [:db, :source, :index].each do |key_symbol|
            factory = factories[key_symbol]
            expected = env_yaml[key_symbol.to_s]
            expect(factory.config_hash).to eq(expected)
          end
        end
      end
    end
  end
end
