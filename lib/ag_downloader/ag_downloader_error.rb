module AgDownloader
  class AgDownloaderError < StandardError; end

  class InvalidUrlError < AgDownloaderError; end

  class InvalidFileError < AgDownloaderError; end
end