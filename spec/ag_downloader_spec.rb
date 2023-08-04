# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe AgDownloader::CLI do
  let(:options) { described_class.new }

  it 'has a version number' do
    expect(AgDownloader::VERSION).not_to be nil
  end

  describe 'cmd options' do
    before do
      @original_stdout = $stdout
      $stdout = StringIO.new
    end

    after { $stdout = @original_stdout }

    context 'when valid data provided' do
      it 'help flag provided' do
        ARGV.clear
        ARGV.concat %w[--help]

        described_class.new.parse.run

        expect($stdout.string).to include('Usage: ag  [OPTIONS] SOURCE')
      end
    end

    context 'when invalid data provided' do
      it 'source does not provided' do
        ARGV.clear

        described_class.new.parse.run

        expect($stdout.string).to include("Error: argument 'source' must be provided")
      end

      it 'file in local machine does not exist' do
        ARGV.clear
        ARGV.concat %w[-f not_exist_file.txt]

        expect_any_instance_of(AgDownloader::Logger).to receive(:error).with('`not_exist_file.txt` File does not exist')

        described_class.new.parse.run
      end

      it 'file in the host does not exist' do
        ARGV.clear
        ARGV.concat %w[-u some_invalid_url]

        expect_any_instance_of(AgDownloader::Logger).to receive(:error).with('`some_invalid_url` is not a valid URL')

        described_class.new.parse.run
      end
    end

    context '#download' do
      let(:params) { { source: 'https://example.com/file.txt', url: true } }
      let(:urls) { %w[http://example.com/image1.jpg http://example.com/image2.jpg] }

      before do
        allow(options).to receive(:params).and_return(params)
        allow(options).to receive(:batch_read).and_return(urls)
        allow(options).to receive(:validates).and_return(true)
        allow(::AgDownloader::Download).to receive_message_chain(:new, :batch_download)
      end

      it 'downloads urls from a source' do
        expect(options).to receive(:batch_read).with(source: 'https://example.com/file.txt', type: :url)
        expect(options).to receive(:validates).twice
        expect(::AgDownloader::Download).to receive_message_chain(:new, :batch_download)
        options.download
      end
    end

    context '#run' do
      before do
        allow(options).to receive(:puts)
        allow(options).to receive(:help)
        allow(options).to receive(:download)
      end

      it 'runs without errors' do
        expect { options.run }.not_to raise_error
      end
    end
  end
end
