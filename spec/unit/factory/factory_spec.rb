require 'spec_helper'

module Factory
  module Factory
    describe '#load_file' do
      it 'loads a single-environment config file' do
        env = Factory.load_file('spec/data/single-environment.yml')
        expect(env).to be_an(Environment)
        expect(env.name).to eq(Environments::DEFAULT_ENVIRONMENT)
      end

      it 'loads a multi-environment config file' do
        envs = Factory.load_file('spec/data/multiple-environments.yml')
        expect(envs).to be_a(Hash)
        expect(envs.size).to eq(4)
        %w(defaults development test production).each do |env_name|
          env = envs[env_name]
          expect(env).to be_an(Environment)
          expect(env.name).to eq(env_name)
        end
      end
    end
  end
end
