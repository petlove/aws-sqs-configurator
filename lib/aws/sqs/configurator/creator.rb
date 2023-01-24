# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Creator
        attr_accessor :queues, :created

        def initialize
          clear!
          @queues = AWS::SQS::Configurator.queues!
        end

        def create!
          tap { queues_by_region.each { |region_queues| create_by_region(*region_queues) } }
        end

        private

        def queues_by_region
          @queues.group_by(&:region)
        end

        def create_by_region(region, queues)
          client = Client.new(region)

          queues.each { |queue| create_queue(queue, client) }
        end

        def create_queue(queue, client)
          queue.dead_letter&.create!(client)
          queue.create!(client)
          add_created(queue)
        end

        def clear!
          @created = []
        end

        def add_created(queue)
          Logger.info("Queue created: #{queue.name_formatted} - #{queue.region}")
          @created << queue
        end
      end
    end
  end
end
