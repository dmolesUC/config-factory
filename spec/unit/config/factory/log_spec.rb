# frozen_string_literal: true

require 'spec_helper'
require 'time'

module Config
  module Factory
    describe 'log' do
      it 'logs to stdout in a timestamp-first format' do
        out = StringIO.new
        Factory.log_device = out
        begin
          msg = 'I am a log message'
          Factory.log.warn(msg)
          logged = out.string
          expect(logged).to include(msg)
          timestamp_str = logged.split[0]
          timestamp = Time.parse(timestamp_str)
          expect(timestamp.to_date).to eq(Time.now.utc.to_date)
        ensure
          Factory.log_device = $stdout
        end
      end
    end
  end
end
