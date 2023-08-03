# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AgDownloader::Validations do
  let(:klass) { Class.new { include AgDownloader::Validations } }
  let(:klass_object) { klass.new }
  let(:valid_file) { File.expand_path('spec/fixtures/valid_file.txt') }
  let(:valid_url) { 'https://www.example.com' }

  context 'validate file' do
    let(:invalid_file) { File.expand_path('spec/fixtures/invalid_file.txt') }

    it 'returns true' do
      expect(klass_object.validates(valid_file, type: :file)).to eq(true)
    end

    it 'raises an error' do
      expect { klass_object.validates(invalid_file, type: :file) }
        .to raise_error(AgDownloader::InvalidFileError)
    end
  end

  context 'validate url' do
    let(:invalid_url) { 'invalid_url' }

    it 'returns true' do
      expect(klass_object.validates(valid_url, type: :url)).to eq(true)
    end

    it 'raises an error' do
      expect { klass_object.validates(invalid_url, type: :url) }
        .to raise_error(AgDownloader::InvalidUrlError)
    end
  end

  context 'invalid resource' do
    it 'raises an error' do
      expect { klass_object.validates(valid_file, type: :invalid_source) }
        .to raise_error(AgDownloader::InvalidSourceError)
    end

    it 'raises an error' do
      expect { klass_object.validates(valid_url, type: :invalid_source) }
        .to raise_error(AgDownloader::InvalidSourceError)
    end
  end
end
