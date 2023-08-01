# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AgDownloader::Options do
  it "has a version number" do
    expect(AgDownloader::VERSION).not_to be nil
  end

  before do
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stdout = @original_stdout
  end
  context 'when valid data provided' do
    it 'file provided' do
      ARGV.clear
      ARGV.concat %w[file.txt]

      described_class.new.parse.run

      expect($stdout.string).to include("Downloading...")
    end

    it 'help flag provided' do
      ARGV.clear
      ARGV.concat %w[--help]

      described_class.new.parse.run

      expect($stdout.string).to include('Usage: ag  [OPTIONS] FILE')
    end
  end

  context 'when invalid data provided' do
    it 'file does not provided' do
      ARGV.clear

      described_class.new.parse.run

      expect($stdout.string).to include("Error: argument 'file' must be provided")
    end
  end
end
