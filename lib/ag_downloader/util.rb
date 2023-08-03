# frozen_string_literal: true

require_relative 'http'
require_relative 'validations'

module AgDownloader
  ## Path: lib/ag_downloader/util.rb
  # Module to work with files
  # Module includes method to read from file or url and split it by spaces
  #
  # Example:
  #  klass = Class.new { include AgDownloader::Util }
  #  klass_object = klass.new
  #  klass_object.batch_read(filepath: 'path/to/file')
  #
  # @param filepath [String] path to file
  # @param type [Symbol] type of source
  # @return [Array] array of urls
  module Util
    include ::AgDownloader::Validations
    def batch_read(source:, type:)
      validates(source, type: :source)
      return read_from_disk(file: source) if type&.to_sym == :file
      return read_from_url(url: source) if type&.to_sym == :url

      raise AgDownloader::InvalidSourceError, 'Source type is not valid'
    end

    def read_from_url(url:)
      validates(url, type: :url)
      http = AgDownloader::Http.new(url:)
      http.send_request(method: :get) do |response|
        return response.body.split(' ')
      end
    end

    def read_from_disk(file:)
      validates(file, type: :file)
      File.open(file, 'r').read.split(' ')
    end
  end
end
