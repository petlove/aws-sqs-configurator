# frozen_string_literal: true

require 'aws/sqs/configurator'
require 'rails'

module AWS
  module SQS
    module Configurator
      class Railtie < Rails::Railtie
        rake_tasks do
          Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f }
        end
      end
    end
  end
end
