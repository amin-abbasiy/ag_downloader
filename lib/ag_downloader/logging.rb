# frozen_string_literal: true

require_relative 'logger'

module AgDownloader
  ## Path: lib/ag_downloader/logging.rb
  # Module to work with logging
  #
  # Example:
  #  class Klass
  #   include AgDownloader::Logging
  #   logger.info('message')
  #  end
  module Logging
    DEFAULT_LOG_LEVEL = Logger::INFO
    DEFAULT_LOG_OUTPUT = $stdout

    def logger
      @logger ||= AgDownloader::Logger.new(DEFAULT_LOG_OUTPUT)
      @logger.level = DEFAULT_LOG_LEVEL
      @logger
    end
  end
end
