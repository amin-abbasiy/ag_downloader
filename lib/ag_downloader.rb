# frozen_string_literal: true

require_relative "ag_downloader/version"
require 'tty-option'

class AgDownloader
  include TTY::Option

  usage do
    program "ag"

    command 'download'

    desc "Get file and download images from urls inside the file"

    example "$ ag download `path/to/file`"
  end

  argument :file do
    required
    desc "The name of the file to use"
  end

  flag :help do
    short "-h"
    long "--help"
    desc "Print usage"
  end

  def run
    if params[:help]
      puts help
    elsif params[:file]
      puts "Downloading..."
    elsif params.errors.any?
      puts params.errors.summary
    else
      puts params.to_h
    end
  end
end

cmd = AgDownloader.new
cmd.parse
cmd.run
