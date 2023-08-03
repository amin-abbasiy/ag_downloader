# frozen_string_literal: true

module AgDownloader
  class AgDownloaderError < StandardError; end

  class InvalidUrlError < AgDownloaderError; end

  class InvalidFileError < AgDownloaderError; end

  class InvalidSourceError < AgDownloaderError; end
end
