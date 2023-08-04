# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/rspec'

RSpec.describe AgDownloader::Http do
  let(:url) { 'https://upload.wikimedia.org/wikipedia/commons/3/3f/Puncakjaya.jpg' }
  let(:stub_url) { 'https://upload.wikimedia.org/wikipedia/commons/3/3f/Puncakjaya.jpg' }

  let(:http) { described_class.new(url:) }

  context 'Http successful' do
    it 'returns a URI object for the given URL' do
      expect(http.uri).to be_a(URI)
      expect(http.uri.to_s).to eq(url)
    end

    it 'returns a Net::HTTP::Get request object' do
      expect(http.get).to be_a(Net::HTTP::Get)
    end

    it 'returns a Net::HTTP::Get request object' do
      expect(http.head).to be_a(Net::HTTP::Head)
    end
  end

  context 'GET Successful request' do
    let(:image_path) { File.expand_path('spec/fixtures/Puncakjaya.jpg') }
    let(:image_data) { File.open(image_path, 'rb', &:read) }

    before do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: image_data, headers: {})
    end

    it 'sends a request to the provided URL' do
      response = http.send_request(method: :get)

      expect(response.code).to eq('200')
      expect(response.body).to eq(image_data)
    end

    it 'yields the response to a provided block' do
      yielded = false
      http.send_request(method: :get) do |response|
        expect(response.body).to eq(image_data)
        yielded = true
      end
      expect(yielded).to be_truthy
    end
  end

  context 'HEAD Successful request' do
    before do
      stub_request(:head, stub_url)
        .to_return(status: 200)
    end

    it 'sends a request to the provided URL' do
      response = http.send_request(method: :head)

      expect(response.code).to eq('200')
    end

    it 'yields the response to a provided block' do
      yielded = false
      http.send_request(method: :head) do
        yielded = true
      end
      expect(yielded).to be_truthy
    end
  end

  context 'Http failed' do
    it 'raises error on network failure' do
      allow(Net::HTTP).to receive(:start).and_raise(SocketError)
      http = AgDownloader::Http.new(url:)

      expect { http.send_request(method: :get) }.to raise_error(SocketError)
    end

    it 'raises error on request timeout' do
      allow(Net::HTTP).to receive(:start).and_raise(Net::ReadTimeout)
      http = AgDownloader::Http.new(url:)

      expect { http.send_request(method: :get) }.to raise_error(Net::ReadTimeout)
    end
  end
end
