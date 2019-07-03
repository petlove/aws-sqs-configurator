# frozen_string_literal: true

require 'vcr'
require 'webmock'

class VCRConfig
  def self.configure
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
      config.cassette_library_dir = 'spec/cassettes'
      config.hook_into :webmock
      config.ignore_localhost = true
      config.configure_rspec_metadata!
    end
  end
end
