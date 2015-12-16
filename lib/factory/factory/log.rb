module Factory
  module Factory

    class << self
      attr_writer :log
    end

    # Gets the logger for the module. Default logger logs to `$stdout`.
    # @return [Logger] the logger
    def self.log
      self.log_device = $stdout unless @log
      @log
    end

    # Sets the log device. Defaults to `$stdout`
    # @param value [IO] the log device
    def self.log_device=(value)
      @log = new_logger(logdev: value)
    end

    private

    def self.new_logger(logdev:, level: Logger::DEBUG, shift_age: 10, shift_size: 1024 * 1024)
      logger = Logger.new(logdev, shift_age, shift_size)
      logger.level = level
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.to_time.utc} #{severity} -#{progname}- #{msg}\n"
      end
      logger
    end

  end
end
