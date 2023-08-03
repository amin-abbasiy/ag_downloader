# frozen_string_literal: true

require_relative 'ag_downloader/version'
require_relative 'ag_downloader/validations'
require_relative 'ag_downloader/download'
require_relative 'ag_downloader/util'
require 'tty-option'

module AgDownloader
  ## Path: lib/ag_downloader.rb
  # Class to work with command line options
  # Example:
  #   klass = AgDownloader::Options.new
  #   klass.parse
  #   klass.run
  #
  # @param file [String] path to file
  # @param help [Boolean] print usage
  class Options
    include TTY::Option
    include ::AgDownloader::Validations
    include ::AgDownloader::Util

    usage do
      program 'ag'

      command ''

      desc 'Get file and download images from urls inside the file'

      example '$ ag download `path/to/file`'
    end

    argument :file do
      required
      desc 'The name of the file to use'
    end

    flag :help do
      short '-h'
      long '--help'
      desc 'Print usage'
    end

    def download
      validate_file(file: params[:file])
      urls = batch_read(filepath: params[:file])
      urls.each { |url| validate_url(url:) }
      ::AgDownloader::Download.new.batch_download(urls:)
      puts 'Downloading...'
    end

    # rubocop:disable Metrics/AbcSize
    def run
      puts help if params[:help]
      download if params[:file]
      puts params.errors.summary if params.errors.any?
    rescue AgDownloader::InvalidFileError => e
      puts e
    rescue AgDownloader::InvalidUrlError => e
      puts e
    rescue SocketError => e
      puts e
    rescue Net::ReadTimeout => e
      puts e
    end
    # rubocop:enable Metrics/AbcSize
  end
end
