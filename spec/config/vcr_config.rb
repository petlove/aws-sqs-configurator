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

      config.filter_sensitive_data('<AWS_SQS_ENDPOINT>') { ENV['AWS_SQS_ENDPOINT'] }
      config.filter_sensitive_data('<AWS_ACCOUNT_ID>') { ENV['AWS_ACCOUNT_ID'] }
      config.filter_sensitive_data('<AWS_ACCESS_KEY_ID>') { ENV['AWS_ACCESS_KEY_ID'] }
      config.filter_sensitive_data('<AWS_SECRET_KEY>') { ENV['AWS_SECRET_KEY'] }
    end
  end
end
