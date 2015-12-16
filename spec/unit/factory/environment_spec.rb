require 'spec_helper'

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
        end
      end
    end
  end
end
