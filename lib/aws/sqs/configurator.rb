# frozen_string_literal: true

require 'aws/sqs/configurator/version'
require 'aws/sqs/configurator/client'
require 'aws/sqs/configurator/logger'
require 'aws/sqs/configurator/queue'
require 'aws/sqs/configurator/reader'
require 'aws/sqs/configurator/creator'
require 'aws/sns/configurator'
require 'aws-sdk-sqs'

module AWS
  module SQS
    module Configurator
      require 'aws/sqs/configurator/railtie' if defined?(Rails)

      class << self
        def read!
          Reader.new.queues!
        end

        def create!(force)
          Creator.new(force).create!
        end
      end
    end
  end
end
