# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/rspec'

RSpec.describe AgDownloader::Util do
  let(:klass) { Class.new { include AgDownloader::Util } }
  let(:klass_object) { klass.new }
  let(:valid_file) { File.expand_path('spec/fixtures/valid_file.txt') }
  let(:image_path) { File.expand_path('spec/fixtures/image.jpeg') }
  let(:valid_url) { 'https://example.com' }
  let(:invalid_file) { 'invalid_file' }
  let(:invalid_url) { 'invalid_url' }

  context 'when source provided' do
    it 'returns true' do
      expect(klass_object.batch_read(source: valid_file, type: :file)).to eq(%w[https://www.example.com/file1.png
                                                                                https://www.example.com/file2.png])
    end

    it 'reads from the url and splits by spaces' do
      stub_request(:get, valid_url)
        .to_return(status: 200, body: 'https://www.example.com/file1.png https://www.example.com/file2.png')

      result = klass_object.batch_read(source: valid_url, type: :url)
      expect(result).to eq(%w[https://www.example.com/file1.png https://www.example.com/file2.png])
    end
  end

  context 'when source is not valid' do
    it 'raises an error for invalid file' do
      expect { klass_object.batch_read(source: invalid_file, type: :file) }
        .to raise_error(AgDownloader::InvalidFileError)
    end

    it 'raises an error for invalid source' do
      expect { klass_object.batch_read(source: valid_file, type: :invalid) }
        .to raise_error(AgDownloader::InvalidSourceError)
    end

    it 'raises an error for invalid url' do
      expect { klass_object.batch_read(source: invalid_url, type: :url) }
        .to raise_error(AgDownloader::InvalidUrlError)
    end
  end
end
