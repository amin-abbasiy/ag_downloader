# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe AgDownloader::Util do
  let(:klass) { Class.new { include AgDownloader::Util } }
  let(:klass_object) { klass.new }
  let(:valid_path) { File.expand_path('spec/fixtures/valid_file.txt') }
  let(:image_path) { File.expand_path('spec/fixtures/image.jpeg') }

  context 'when file provided' do
    it 'returns true' do
      expect(klass_object.batch_read(filepath: valid_path)).to eq(%w[https://www.example.com/file1.png
                                                                     https://www.example.com/file2.png])
    end
  end
end
