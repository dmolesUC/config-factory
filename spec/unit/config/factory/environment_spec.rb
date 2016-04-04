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
        it 'reads a standard ActiveRecord db config' do
          yaml_hash = {
            'adapter' => 'sqlite3',
            'database' => 'db/development.sqlite3',
            'pool' => 5,
            'timeout' => 5000
          }
          Environment.new(name: :test, configs: yaml_hash)
        end
      end

      describe '#load_file' do
        it 'loads a single-environment config file' do
          env = Environment.load_file('spec/data/single-environment.yml')
          expect(env).to be_an(Environment)
          expect(env.name).to eq(Environments::DEFAULT_ENVIRONMENT)

          pers = PersistenceConfig.for_environment(env, :persistence)
          expect(pers).to be_a(DBConfig)
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

      describe '#to_s' do
        it 'includes the name' do
          env = Environment.load_file('spec/data/single-environment.yml')
          expect(env.to_s).to include(Environments::DEFAULT_ENVIRONMENT.to_s)
        end

        it 'includes the hash' do
          h = {
            'db' => {
              'adapter' => 'mysql2',
              'encoding' => 'utf8',
              'pool' => 5,
              'database' => 'example_prod',
              'host' => 'mysql-dev.example.org',
              'port' => 3306
            },
            'source' => {
              'protocol' => 'OAI',
              'oai_base_url' => 'http://oai.example.org/oai',
              'metadata_prefix' => 'some_prefix',
              'set' => 'some_set',
              'seconds_granularity' => true
            },
            'index' => {
              'adapter' => 'solr',
              'url' => 'http://solr.example.org/',
              'proxy' => 'http://foo:bar@proxy.example.com/',
              'open_timeout' => 120,
              'read_timeout' => 300
            }
          }
          env = Environment.load_hash(h)
          expect(env.to_s).to include(h.to_s)
        end
      end

    end
  end
end
