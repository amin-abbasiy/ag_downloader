# frozen_string_literal: true

require 'open-uri'
require 'tty-progressbar'
require_relative 'http'

module AgDownloader
  ## Path: lib/ag_downloader/download.rb
  # Class includes methods to download files concurrently
  # Class is thread safe and uses mutex to synchronize threads is shard resources
  # Class includes methods to download files and show progress bar
  #
  # Example:
  #   klass = AgDownloader::Download.new
  #   klass.batch_download(urls: ['https://www.example.com', 'https://www.example2.com'])
  #
  # @param urls [Array] array of urls to download
  class Download
    def initialize
      @mutex = Mutex.new
      @bars = TTY::ProgressBar::Multi.new('main [:bar] :percent')
    end

    def batch_download(urls:)
      @threads = []
      urls.each do |url|
        @threads << Thread.new do
          http = AgDownloader::Http.new(url:)
          download(http:)
        end
      end

      @threads.each(&:join)
    end

    def filename(http:)
      File.basename(http.uri.path)
    end

    def progress(response:, http:)
      @mutex.synchronize do
        @bars.register("#{filename(http:)} [:bar]", bar_format: :rectangle, total: response.content_length * 4)
      end
    end

    def download(http:)
      http.send_request(method: :get) do |response|
        progressbar = progress(response:, http:)
        File.open(filename(http:), 'ab') do |io|
          response.read_body do |chunk|
            progressbar.advance(chunk.size)
            io.write(chunk)
          end
        end
      end
    end

    private

    attr_reader :bars
  end
end
