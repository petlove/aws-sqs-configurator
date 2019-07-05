# frozen_string_literal: true

require 'bundler/setup'
require 'aws/sqs/configurator'

namespace :sqs do
  desc 'Create queues by config (./config/aws-sqs-configurator.yml)'
  task :create do
    options = ARGV[1..-1]
    force = options.find { |option| ['force'].include?(option) }
    AWS::SQS::Configurator.create!(force)
  end
end
