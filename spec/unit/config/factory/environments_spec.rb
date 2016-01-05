require 'spec_helper'

module Config
  module Factory
    module Environments
      describe '#load_file' do
        it 'loads a multi-environment config file' do
          envs = Environments.load_file('spec/data/multiple-environments.yml')
          expect(envs).to be_a(Hash)
          expect(envs.size).to eq(4)
          [:defaults, :development, :test, :production].each do |env_name|
            env = envs[env_name]
            expect(env).to be_an(Environment)
            expect(env.name).to eq(env_name)
          end
        end
      end
    end
  end
end
