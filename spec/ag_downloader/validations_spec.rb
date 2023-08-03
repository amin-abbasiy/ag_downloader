# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AgDownloader::Validations do
  let(:klass) { Class.new { include AgDownloader::Validations } }
  let(:klass_object) { klass.new }

  describe '#validate_file' do
    let(:valid_file) { File.expand_path('spec/fixtures/valid_file.txt') }
    let(:invalid_file) { File.expand_path('spec/fixtures/invalid_file.txt') }

    context 'when file provided' do
      it 'returns true' do
        expect(klass_object.validate_file(file: valid_file)).to eq(true)
      end
    end

    context 'when file does not exist' do
      it 'raise error' do
        expect { klass_object.validate_file(file: invalid_file) }.to raise_error(AgDownloader::InvalidFileError)
      end
    end
  end

  describe '#validate_url' do
    let(:valid_url) { 'https://www.example.com' }
    let(:invalid_url) { 'invalid_url' }

    context 'when url provided' do
      it 'returns true' do
        expect(klass_object.validate_url(url: valid_url)).to eq(true)
      end
    end

    context 'when url does not exist' do
      it 'raise error' do
        expect { klass_object.validate_url(url: invalid_url) }.to raise_error(AgDownloader::InvalidUrlError)
      end
    end
  end
end
