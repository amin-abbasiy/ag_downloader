# frozen_string_literal: true

require_relative 'ag_downloader_error'

module AgDownloader
  ## Path: lib/ag_downloader/validations.rb
  # Module to validate urls and files before downloading
  # Module includes validation for urls, files and protocols
  #
  # Example:
  #   klass = Class.new { include AgDownloader::Validations }
  #   klass_object = klass.new
  #   klass_object.validate_url(url: 'https://www.example.com')
  #   klass_object.validate_file(file: 'path/to/file')
  #
  # Raises:
  #   AgDownloader::InvalidUrlError
  #   AgDownloader::InvalidFileError
  #
  # Returns:
  #   true
  #
  # @param url [String] url to validate
  # @param file [String] file to validate
  # @return [Boolean] true
  module Validations
    def validate_url(url:)
      raise AgDownloader::InvalidUrlError, 'URL is not valid' unless url =~ URI::DEFAULT_PARSER.make_regexp
      raise AgDownloader::InvalidUrlError, 'URL is invalid' unless validate_protocols(url:)

      true
    end

    def validate_file(file:)
      raise AgDownloader::InvalidFileError, 'File does not exist' unless File.exist?(file)

      true
    end

    def validate_protocols(url:)
      url = URI.parse(url)
      url.is_a?(URI::HTTPS) || url.is_a?(URI::HTTP)
    end
  end
end
