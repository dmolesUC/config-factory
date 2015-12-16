require 'spec_helper'

module Factory
  describe Factory do
    describe '#load_file' do
      it 'loads a single-environment config file' do
        envs = Factory.load_file('spec/data/single-environment.yml')
        expect(envs).to be_a(Hash)
        expect(envs.size).to eq(1)
      end

      it 'loads a multi-environment config file' do
        envs = Factory.load_file('spec/data/multiple-environments.yml')
        expect(envs).to be_a(Hash)
        expect(envs.size).to eq(4)
      end
    end
  end
end
