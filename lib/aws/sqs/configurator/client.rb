# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Client
        attr_reader :region

        def initialize(region)
          @region = region
        end

        def aws
          @aws ||= Aws::SQS::Client.new(options)
        end

        def options
          {
            region: region,
            endpoint: ENV['AWS_SQS_ENDPOINT']
          }
        end
      end
    end
  end
end
