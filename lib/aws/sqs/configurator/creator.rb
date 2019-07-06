# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Creator
        attr_accessor :queues, :force, :created, :found

        def initialize(force = false)
          clear!
          @force = force
          @queues = Reader.new.queues!
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

          queues.each { |queue| create_queue(queue, client) if @force || !find_queue(queue, client) }
        end

        def find_queue(queue, client)
          queue.find!(client).tap { |found| add_found(queue) if found }
        end

        def create_queue(queue, client)
          queue.dead_letter.create!(client) if queue.dead_letter && (@force || !find_queue(queue.dead_letter, client))
          queue.create!(client)
          add_created(queue)
        end

        def clear!
          @created = []
          @found   = []
        end

        def add_created(queue)
          Logger.info("Created: #{queue.name_formatted} - #{queue.region}")
          @created << queue
        end

        def add_found(queue)
          Logger.info("Found: #{queue.name_formatted} - #{queue.region}")
          @found << queue
        end
      end
    end
  end
end
