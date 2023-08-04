# frozen_string_literal: true

require 'logger'

module AgDownloader
  ## Path: lib/ag_downloader/logger.rb
  # Class to log messages
  # Class includes methods to log messages
  # Example:
  #   klass = AgDownloader::Logger.new(logdev)
  #   klass.info('message')
  #
  # Raises:
  #  ArgumentError
  #
  # @param logdev [IO|String] log output
  class Logger < Logger
    SEVERITY = %w[VERBOSE INFO WARN ERROR FATAL].freeze

    def initialize(logdev)
      super(logdev, progname: 'ag_downloader')
    end

    def error(message = nil)
      add(ERROR, message)
    end

    def fatal(message = nil)
      add(FATAL, message)
    end

    def info(message = nil)
      add(INFO, message)
    end

    def warn(message = nil)
      add(WARN, message)
    end
  end
end
