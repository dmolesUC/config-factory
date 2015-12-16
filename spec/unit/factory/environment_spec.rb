require 'spec_helper'

module Factory
  describe Environment do
    before(:each) do
      @env = Environment.new(YAML.load_file('spec/data/single-environment.yml'))
    end

    describe '#factories' do
      factories = @env.factories
      expect(factories.size).to eq(3)
    end
  end
end
