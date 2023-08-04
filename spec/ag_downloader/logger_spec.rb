# frozen_string_literal: true

require 'stringio'
require_relative '../spec_helper'

RSpec.describe AgDownloader::Logger do
  let(:output) { StringIO.new }
  let(:logger) { described_class.new(output) }

  context 'with right messages' do
    it '#info' do
      logger.info('This is an info message')
      output.rewind
      expect(output.string).to include('This is an info message')
    end

    it '#warn' do
      logger.warn('This is a warning')
      output.rewind
      expect(output.string).to include('This is a warning')
    end

    it '#error' do
      logger.error('This is an error')
      output.rewind
      expect(output.string).to include('This is an error')
    end

    it '#fatal' do
      logger.fatal('This is a fatal error')
      output.rewind
      expect(output.string).to include('This is a fatal error')
    end
  end
end
