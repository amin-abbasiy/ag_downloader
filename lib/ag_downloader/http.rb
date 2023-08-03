# frozen_string_literal: true

module AgDownloader
  ## Path: lib/ag_downloader/validations.rb
  # Class to work with http requests
  # Class includes methods to start http request and send http request
  #
  # Example:
  #   klass = AgDownloader::Http.new(url: 'https://www.example.com')
  #   klass.start
  #   klass.send_request(method: <http_method>) { |response| <block> }
  #
  # Raises:
  #   Net::HTTPServerException
  #
  # Returns:
  #   Net::HTTP.start
  #
  # @param url [String] url to download from
  # @param method [Symbol] http method to use
  # @block [Block] block to execute after http request
  class Http
    def initialize(url:)
      @url = url
    end

    def uri
      URI(@url)
    end

    def start
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https')
    end

    def get
      Net::HTTP::Get.new(uri)
    end

    def send_request(method:, &block)
      start.request(public_send(method)) do |response|
        raise ::Net::HTTPServerException 'message' unless response.is_a?(Net::HTTPSuccess)

        block.call(response) if block_given?
      end
    end
  end
end
