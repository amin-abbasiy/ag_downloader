# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AgDownloader::Download do
  let(:http_instance) { instance_double('AgDownloader::Http') }
  let(:response) { instance_double('Net::HTTPResponse') }
  let(:urls) { %w[https://upload.wikimedia.org/wikipedia/commons/3/3f/Puncakjaya.jpg https://upload.wikimedia.org/wikipedia/commons/3/3f/Puncakjaya.jpg] }
  let(:download_instance) { described_class.new }

  before do
    allow(AgDownloader::Http).to receive(:new).and_return(http_instance)
    allow(http_instance).to receive(:uri).and_return(URI(urls.first))
    allow(http_instance).to receive(:send_request)
  end

  context '#batch_download and #filename' do
    it 'creates a new Thread for each url' do
      expect(Thread).to receive(:new).twice.and_call_original

      download_instance.batch_download(urls:)
    end

    it 'returns the filename from the url' do
      filename = download_instance.filename(http: http_instance)

      expect(filename).to eq('Puncakjaya.jpg')
    end
  end

  context '#download' do
    before do
      allow(response).to receive(:content_length).and_return(100)
      allow(response).to receive(:read_body)
      allow(http_instance).to receive(:send_request).and_yield(response)
    end

    it 'opens a file and writes to it' do
      file_path = File.expand_path('spec/fixtures/Puncakjaya.jpg')

      download_instance.download(http: http_instance)

      file_content = File.read(file_path)
      expect(file_content.size).to be_positive
    end

    it 'sends a GET request' do
      expect(http_instance).to receive(:send_request).with(method: :get)

      download_instance.download(http: http_instance)
    end
  end

  context '#progress' do
    before do
      allow(response).to receive(:content_length).and_return(100)
    end

    it 'registers a new progress bar' do
      progress_bar = download_instance.progress(response:, http: http_instance)

      expect(progress_bar).to be_an_instance_of(TTY::ProgressBar)
    end
  end
end
