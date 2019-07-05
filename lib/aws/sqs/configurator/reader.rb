# frozen_string_literal: true

require 'yaml'

module AWS
  module SQS
    module Configurator
      class Reader
        class WithoutContentError < StandardError; end

        PATH = './config/aws-sqs-configurator.yml'

        attr_accessor :config

        def initialize
          build_config!(JSON.parse(read_file!.to_json, symbolize_names: true))
        end

        def queues!
          @config[:queues].map(&method(:build_queue!))
        end

        private

        def read_file!
          YAML.safe_load(File.read(PATH)).tap(&method(:handle_options!))
        rescue Errno::ENOENT, WithoutContentError
          { queues: [] }
        end

        def handle_options!(options)
          raise WithoutContentError unless options

          options['queues'] = [] unless options['queues']
        end

        def build_config!(value = { queues: [] })
          @config = value
        end

        def default_config
          @default_config ||= @config.slice(
            :region, :prefix, :suffix, :environment, :visibility_timeout, :max_receive_count, :message_retention_period,
            :fifo, :dead_letter_queue, :dead_letter_queue_suffix, :content_based_deduplication
          )
        end

        def build_queue!(options)
          Queue.new(default_config.merge(options))
        end
      end
    end
  end
end
