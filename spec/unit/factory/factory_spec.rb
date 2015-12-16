require 'spec_helper'

module Factory
  describe Factory do
    describe '#load_file' do
      it 'loads a single-environment config file' do
        envs = Factory.load_file('spec/data/single-environment.yml')
        expect(envs).to be_an(Environment)
      end

      it 'loads a multi-environment config file' do
        envs = Factory.load_file('spec/data/multiple-environments.yml')
        expect(envs).to be_a(Hash)
        expect(envs.size).to eq(4)
        %w(defaults development test production).each do |env_name|
          env = envs[env_name]
          expect(env).to be_an(Environment)
        end
      end
    end
  end
end
