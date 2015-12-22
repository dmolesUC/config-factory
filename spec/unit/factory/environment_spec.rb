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
        it 'registers the configurations' do
          yaml_hash = YAML.load_file('spec/data/single-environment.yml')
          env = Environment.new(name: 'test', hash: yaml_hash)
          [:db, :source, :index].each do |key|
            expected = yaml_hash[key.to_s].map { |k, v| [k.to_sym, v] }.to_h
            expect(env.config_for(key)).to eq(expected)
          end
        end
      end
    end
  end
end
