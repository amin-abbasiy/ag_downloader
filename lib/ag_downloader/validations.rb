# frozen_string_literal: true

require_relative 'ag_downloader_error'
require_relative 'http'

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
  #   AgDownloader::InvalidSourceError
  #
  # Returns:
  #   true
  #
  # @param url [String] url to validate
  # @param source [String] source to validate
  # @param type [Symbol] type of source to validate
  # @return [Boolean] true
  module Validations
    VALID_SOURCE_TYPES = %i[url file source].freeze
    def validates(source, type:)
      validate_source_types(type:)
      validate_url(url: source) if type == :url
      validate_file(file: source) if type == :file

      true
    end

    private

    def validate_source_types(type:)
      raise AgDownloader::InvalidSourceError, "`#{type}` Source is not valid" unless VALID_SOURCE_TYPES.include?(type)
    end

    def validate_url(url:)
      raise AgDownloader::InvalidUrlError, "`#{url}` is not a valid URL" unless url =~ URI::DEFAULT_PARSER.make_regexp
      raise AgDownloader::InvalidUrlError, "`#{url}` does not have valid scheme" unless validate_protocols(url:)

      true
    end

    def validate_file(file:)
      raise AgDownloader::InvalidFileError, "`#{file}` File does not exist" unless File.exist?(file)

      true
    end

    def validate_protocols(url:)
      url = URI.parse(url)
      url.is_a?(URI::HTTPS) || url.is_a?(URI::HTTP)
    end
  end
end
