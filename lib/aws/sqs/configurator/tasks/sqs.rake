# frozen_string_literal: true

require 'bundler/setup'
require 'aws/sqs/configurator'

namespace :aws do
  namespace :sqs do
    desc 'Create queues by config (./config/aws-sqs-configurator.yml)'
    task :create do |_t, _args|
      AWS::SQS::Configurator.create!
    end
  end
end
