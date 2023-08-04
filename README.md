# AgDownloader

Welcome to AgDownloader! This library is a simple cmd tool to download images concurrently and thread-safe

System uses ruby 3.2.2 syntax, if you run it in lower version of ruby it will raise syntax error.

## Table of Contents

  - [Solution](#solution)
  - [Considerations](#considerations)
  - [Features](#features)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Standalone](#standalone)
    - [In your application](#in-your-application)
  - [Usage](#usage)
  - [Development](#development)
  - [Next Version Improvements](#next-version-improvements)
 

## Solution

System Divided into modules and classes and each component has a single responsibility and will be used as interface it the system.
- `AgDownloader::Util` helpers for handling file related concerns like reading and writing files.
- `AgDownloader::HTTP` For handling HTTP requests all HTTP request will be initiated by this class.
- `AgDownloader::Validations` For validating url and file content, this module provides `validates` method as interface for the system.
- `Agdownloader::Download` Main class which handles all the logic and has a public methods `batch_download` which will be used as interface for the system.
- `AgDownloader::AgDownloaderError` Base class for all errors in the system.
- `AgDownloader::CLI` is a interface in cmd and your command will be handled by this class.
- `AgDownloader::Logger` is a simple logger class which will be used for logging in the system.
- `AgDownloader::Logging` interface for logger class and will be used in the system.

## Considerations

- Reason not using `open-uri` is memory usage, system reads downloaded file content in chunks and will not load all data in memory
- For HTTP request its better to use `Net::HTTP` instead of `OpenURI` because it has more control over the request and response and also it has more options to set for the request, also its possible to use `Faraday` or `Typhoeus` but they are more complex but they coming with dependencies and not necessary for this task.
- All HTTP requests are concurrent and thread-safe and will be handled by `Net::HTTP` and `Thread` classes
- Since system is IO-intensive there is no need to parallelize the process and concurrent requests are enough to handle the task especially its the case in bigger files.

## Installation

### Prerequisites

- Ruby v3.2.2

### Standalone

There is already a build of application in the root directory of the project. so you can install it locally.
Clone the repository and run:

```bash
$ gem install ag_downloader-0.1.0.gem
```

You are all set to use the application. refer to [Usage](#usage) section for more information.

### In your application

Add this line to your application's Gemfile:

```ruby
gem 'ag_downloader'
```
or install it yourself as:

    $ gem install ag_downloader

## Usage

After installing the gem, you can use it in your terminal. The gem has two commands:

This app uses ruby as interpreter and has executable file and will be installed in gem path is your system
which makes it usable in any path in your terminal and does not need to run it in specific path.

```bash
$ ag -u https://www.example.com/links_file.txt
```
This command will check url and validates it and after that will validates and download all images in the file and save them in the current directory.

or you can pass local file to the command line:

```bash
$ ag -f path/to/file/links_file.txt
```

This way all the links in the file will be validated and files will be downloaded.

## Development

After checking out the repo, to install dependencies run:

```bash
$ bin/setup
```

Then, to run the tests run:

```bash
$ bundle exec rspec
```

## Next Version Improvements

- Adding ability to capture errors and retry the request
- Adding ability to pick up uncompleted downloads
- Adding ability to set number of concurrent requests
- Adding ability to set number of retries for requests
- System Errors are implemented in and all errors are inherited from `AgDownloader::AgDownloaderError` and class could be extend for more functionality like formatting error and as template for subclasses.
- Adding format to logger to customize the output
