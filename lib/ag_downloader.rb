# frozen_string_literal: true

require_relative 'ag_downloader/version'
require_relative 'ag_downloader/validations'
require_relative 'ag_downloader/download'
require_relative 'ag_downloader/util'
require_relative 'ag_downloader/logging'
require 'tty-option'

module AgDownloader
  ## Path: lib/ag_downloader.rb
  # Class to work with command line options
  # Example:
  #   klass = AgDownloader::Options.new
  #   klass.parse
  #   klass.run
  #
  # @param source [String] path to file or url
  # @param url [Boolean] flag to indicate url
  # @param file [Boolean] flag to indicate file
  # @param help [Boolean] print usage
  class CLI
    include TTY::Option
    include ::AgDownloader::Validations
    include ::AgDownloader::Util
    include ::AgDownloader::Logging

    usage do
      program 'ag'

      command ''

      desc 'Get file and download images from urls inside the file'

      example '$ ag download -f `path/to/file`'
      example '$ ag download -u `https://www.example.com`'
    end

    argument :source do
      required
      desc 'Source to download from'
    end

    flag :help do
      short '-h'
      long '--help'
      desc 'Print usage'
    end

    flag :url do
      short '-u'
      long '--url'
      desc 'url containing urls of images'
    end

    flag :file do
      short '-f'
      long '--file'
      desc 'local file containing urls of images'
    end

    # rubocop:disable Metrics/AbcSize
    def download
      type = :url if params[:url]
      type = :file if params[:file]
      logger.info('Reading and Validating the source file...')
      urls = batch_read(source: params[:source], type:)
      urls = urls.map { |url| validates(url, type: :url) }
      logger.info('Read file and ready to download')
      down = ::AgDownloader::Download.new
      logger.info('Downloading...')
      down.batch_download(urls:)
    end

    def run
      puts help if params[:help]
      download if params[:source]
      puts params.errors.summary if params&.errors&.any?
    rescue AgDownloader::InvalidFileError => e
      logger.error(e.message)
    rescue AgDownloader::InvalidUrlError => e
      logger.error(e.message)
    rescue AgDownloader::InvalidSourceError => e
      logger.error(e.message)
    rescue SocketError => e
      logger.error(e.message)
    rescue Net::ReadTimeout => e
      logger.error(e.message)
    rescue ArgumentError => e
      logger.error(e.message)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
