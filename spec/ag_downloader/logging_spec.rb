# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AgDownloader::Logging do
  let(:target_class) { Class.new { include AgDownloader::Logging }.new }

  describe '#logger' do
    subject { target_class.logger }

    it 'returns an instance of AgDownloader::Logger' do
      expect(subject).to be_an_instance_of(AgDownloader::Logger)
    end

    it 'sets the logger level to the default log level' do
      expect(subject.level).to eq(AgDownloader::Logging::DEFAULT_LOG_LEVEL)
    end

    it 'sets the logger output to the default log output' do
      expect(subject.instance_variable_get(:@logdev).dev).to eq(AgDownloader::Logging::DEFAULT_LOG_OUTPUT)
    end

    context 'logging methods' do
      let(:message) { 'sample message' }

      before do
        allow(subject).to receive(:add)
      end

      it 'calls add with correct severity for info' do
        subject.info(message)
        expect(subject).to have_received(:add).with(AgDownloader::Logger::INFO, message)
      end

      it 'calls add with correct severity for warn' do
        subject.warn(message)
        expect(subject).to have_received(:add).with(AgDownloader::Logger::WARN, message)
      end

      it 'calls add with correct severity for error' do
        subject.error(message)
        expect(subject).to have_received(:add).with(AgDownloader::Logger::ERROR, message)
      end

      it 'calls add with correct severity for fatal' do
        subject.fatal(message)
        expect(subject).to have_received(:add).with(AgDownloader::Logger::FATAL, message)
      end
    end
  end
end
