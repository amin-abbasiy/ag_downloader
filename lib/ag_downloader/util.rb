# frozen_string_literal: true

require 'net/http'

module AgDownloader
  ## Path: lib/ag_downloader/util.rb
  # Module to work with files
  # Module includes method to read file and split it by spaces
  #
  # Example:
  #  klass = Class.new { include AgDownloader::Util }
  #  klass_object = klass.new
  #  klass_object.batch_read(filepath: 'path/to/file')
  #
  # @param filepath [String] path to file
  # @return [Array] array of urls
  module Util
    def batch_read(filepath:)
      File.open(filepath, 'r').read.split(' ')
    end
  end
end
