# frozen_string_literal: true

require 'aws/sqs/configurator/version'
require 'aws/sqs/configurator/client'
require 'aws-sdk-sqs'

module AWS
  module SQS
    module Configurator
      require 'aws/sqs/configurator/railtie' if defined?(Rails)
    end
  end
end
