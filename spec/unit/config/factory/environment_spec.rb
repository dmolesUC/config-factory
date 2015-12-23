require 'spec_helper'
require_relative 'fixtures'

module Config
  module Factory
    describe Environment do
      describe '#new' do
        it 'sets the name' do
          env = Environment.new(name: :name, factory_configs: {})
          expect(env.name).to eq(:name)
        end
        it 'requires a name' do
          expect { Environment.new(name: nil, factory_configs: {}) }.to raise_error(ArgumentError)
        end
        it 'requires a symbol name' do
          expect { Environment.new(name: 'name', factory_configs: {}) }.to raise_error(ArgumentError)
        end
        it 'registers the configurations' do
          yaml_hash = YAML.load_file('spec/data/single-environment.yml')
          env = Environment.new(name: :test, factory_configs: yaml_hash)
          %w(db source index).each do |key|
            expect(env.args_for(key)).to eq(yaml_hash[key])
          end
        end
      end
    end
  end
end
