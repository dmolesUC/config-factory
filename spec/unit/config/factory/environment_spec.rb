require 'spec_helper'
require_relative 'fixtures'

module Config
  module Factory
    describe Environment do
      describe '#new' do
        it 'sets the name' do
          env = Environment.new(name: :name, configs: {})
          expect(env.name).to eq(:name)
        end
        it 'requires a name' do
          expect { Environment.new(name: nil, configs: {}) }.to raise_error(ArgumentError)
        end
        it 'requires a symbol name' do
          expect { Environment.new(name: 'name', configs: {}) }.to raise_error(ArgumentError)
        end
        it 'registers the configurations' do
          yaml_hash = YAML.load_file('spec/data/single-environment.yml')
          env = Environment.new(name: :test, configs: yaml_hash)
          %w(db source index).each do |key|
            expect(env.args_for(key)).to eq(yaml_hash[key])
          end
        end
      end

      describe '#load_file' do
        it 'loads a single-environment config file' do
          env = Environment.load_file('spec/data/single-environment.yml')
          expect(env).to be_an(Environment)
          expect(env.name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end
      end
    end
  end
end
