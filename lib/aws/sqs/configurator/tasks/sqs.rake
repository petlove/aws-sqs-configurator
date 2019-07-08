# frozen_string_literal: true

require 'bundler/setup'
require 'aws/sqs/configurator'

namespace :aws do
  namespace :sqs do
    desc 'Create queues by config (./config/aws-sqs-configurator.yml)'
    task :create, [:force] do |_t, args|
      AWS::SQS::Configurator.create!(args[:force] == 'force')
    end
  end
end
