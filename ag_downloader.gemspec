# frozen_string_literal: true

require_relative "lib/ag_downloader/version"

Gem::Specification.new do |spec|
  spec.name = "ag_downloader"
  spec.version = AgDownloader::VERSION
  spec.authors = ["amin-abbasiy"]
  spec.email = ["uamin.en@gmail.com"]

  spec.summary = "Simple Image Downloader"
  spec.description = "download images from a given urls from a given file"
  spec.homepage = "https://github.com/amin-abbasiy/ag_downloader"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/amin-abbasiy/ag_downloader/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ spec/ features/ .git .github appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end