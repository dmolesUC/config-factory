require 'spec_helper'

class MockDBFactory
  include Factory::Factory

  root :db
  key :adapter
end

class MySql2Factory < MockDBFactory
  adapter :mysql2
end

class Sqlite3Factory < MockDBFactory
  adapter :sqlite3
end

module Factory
  module Factory
    describe '#root' do

      it 'sets the root symbol' do
        expect(MockDBFactory.root_symbol).to eq(:db)
      end

      it "doesn't set the root symbol on subclasses" do
        [MySql2Factory, Sqlite3Factory].each do |c|
          expect(c.root_symbol).to be_nil
        end
      end

      it 'registers the root symbol' do
        expect(Factory.factory_for(:db)).to eq(MockDBFactory)
      end
    end

    describe '#key' do
      it 'registers the subclass key' do
        expect(MockDBFactory.key_symbol).to eq(:adapter)
      end

      it 'defines the subclass registration method' do
        { mysql2: MySql2Factory, sqlite3: Sqlite3Factory }.each do |k, v|
          expect(MockDBFactory.subclass_for(k)).to eq(v)
        end
      end
    end
  end
end
