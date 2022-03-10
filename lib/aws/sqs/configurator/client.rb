# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Client
        attr_accessor :aws

        def initialize(region, endpoint)
          if endpoint
            @aws = Aws::SQS::Client.new(region: region, endpoint: endpoint)
            return
          end

          @aws = Aws::SQS::Client.new(region: region)
        end
      end
    end
  end
end
