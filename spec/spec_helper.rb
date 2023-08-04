# frozen_string_literal: true

require_relative '../lib/ag_downloader'
require_relative '../lib/ag_downloader/validations'
require_relative '../lib/ag_downloader/download'
require_relative '../lib/ag_downloader/util'
require_relative '../lib/ag_downloader/http'
require_relative '../lib/ag_downloader/logger'
require_relative '../lib/ag_downloader/logging'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
