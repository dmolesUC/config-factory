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
        it 'requires configs' do
          expect { Environment.new(name: :name, configs: nil) }.to raise_error(ArgumentError)
        end
        it 'requires configs to be hash-like' do
          expect { Environment.new(name: :name, configs: false) }.to raise_error(ArgumentError)
        end
      end

      describe '#load_file' do
        it 'loads a single-environment config file' do
          env = Environment.load_file('spec/data/single-environment.yml')
          expect(env).to be_an(Environment)
          expect(env.name).to eq(Environments::DEFAULT_ENVIRONMENT)
        end

        it 'raises an error for malformed files' do
          bad_yaml = "\t"
          Dir.mktmpdir do |tmpdir|
            bad_yaml_path = "#{tmpdir}/config.yml"
            File.open(bad_yaml_path, 'w') do |f|
              f.write(bad_yaml)
            end
            expect { Environment.load_file(bad_yaml_path) }.to raise_error(Psych::SyntaxError)
          end
        end
      end
    end
  end
end
