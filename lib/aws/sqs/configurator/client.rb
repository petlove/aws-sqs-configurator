# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Client
        attr_accessor :aws

        def initialize(region)
          @aws = Aws::SQS::Client.new({ region: region, endpoint: ENV['AWS_SQS_ENDPOINT'] }.compact)
        end
      end
    end
  end
end
