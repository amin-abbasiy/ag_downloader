require_relative 'ag_downloader_error'

module AgDownloader
  module Validations
    def validate_url(url:)
      raise AgDownloader::InvalidUrlError, "URL is not valid" unless url =~ URI::regexp
    end

    def validate_file(file:)
      raise AgDownloader::InvalidFileError, "File does not exist" unless File.exist?(file)
    end
  end
end