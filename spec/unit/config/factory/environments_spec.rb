require 'spec_helper'

module Config
  module Factory
    module Environments
      describe '#load_file' do
        it 'loads a multi-environment config file' do
          envs = Environments.load_file('spec/data/multiple-environments.yml')
          expect(envs).to be_a(Hash)
          expected = [:defaults, :development, :test, :production]
          expect(envs.size).to eq(expected.size)
          expected.each do |env_name|
            env = envs[env_name]
            expect(env).to be_an(Environment)
            expect(env.name).to eq(env_name)
          end
        end

        it 'reads a standard ActiveRecord DB config' do
          envs = Environments.load_file('spec/data/db-config.yml')
          expect(envs).to be_a(Hash)
          expected = [:development, :test, :production]
          expect(envs.size).to eq(expected.size)
          expected.each do |env_name|
            env = envs[env_name]
            expect(env).to be_an(Environment)
            expect(env.name).to eq(env_name)
          end
        end
      end
    end
  end
end
