# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Queue
        class RequiredFieldError < StandardError; end

        attr_accessor :name, :region, :prefix, :suffix, :environment, :metadata, :name_formatted, :arn, :topics,
                      :visibility_timeout, :max_receive_count, :message_retention_period, :fifo, :dead_letter_queue,
                      :dead_letter_queue_suffix, :content_based_deduplication

        REQUIRED_ACCESSORS = %i[name region].freeze
        VISIBILITY_TIMEOUT_DEFAULT = 60
        MAX_RECEIVE_COUNT_DEFAULT = 7
        MESSAGE_RETETION_PERIOD_DEFAULT = 1_209_600
        FIFO_DEFAULT = false
        DEAD_LETTER_QUEUE_DEFAULT = false
        DEAD_LETTER_QUEUE_SUFFIX_DEFAULT = 'failures'
        CONTENT_BASED_DEDUPLICATION_DEFAULT = false

        def initialize(options)
          options = normalize(options)

          @name = options[:name]
          @region = options[:region]
          @prefix = options[:prefix]
          @suffix = options[:suffix]
          @environment = options[:environment]
          @metadata = options[:metadata]
          @visibility_timeout = options[:visibility_timeout]
          @max_receive_count = options[:max_receive_count]
          @message_retention_period = options[:message_retention_period]
          @fifo = options[:fifo]
          @dead_letter_queue = options[:dead_letter_queue]
          @dead_letter_queue_suffix = options[:dead_letter_queue_suffix]
          @content_based_deduplication = options[:content_based_deduplication]

          build_name_formatted!
          build_arn!
          build_topics!(options[:topics])

          validate!
        end

        private

        def normalize(options)
          return default_options(options) if options.is_a?(String)

          default_options.merge(options.reject { |_key, value| value.nil? })
        end

        def default_options(name = nil)
          {
            name: name,
            region: ENV['AWS_REGION'],
            metadata: {},
            topics: [],
            visibility_timeout: VISIBILITY_TIMEOUT_DEFAULT,
            max_receive_count: MAX_RECEIVE_COUNT_DEFAULT,
            message_retention_period: MESSAGE_RETETION_PERIOD_DEFAULT,
            fifo: FIFO_DEFAULT,
            dead_letter_queue: DEAD_LETTER_QUEUE_DEFAULT,
            dead_letter_queue_suffix: DEAD_LETTER_QUEUE_SUFFIX_DEFAULT,
            content_based_deduplication: CONTENT_BASED_DEDUPLICATION_DEFAULT
          }
        end

        def build_name_formatted!
          @name_formatted = [@prefix, @environment, @name, fifo_suffix].compact.join('_')
        end

        def build_arn!
          @arn = ['arn:aws:sns', @region, account_id, @name_formatted].compact.join(':')
        end

        def build_topics!(topics)
          @topics = topics.map { |topic| AWS::SNS::Configurator::Topic.new(topic) }
        end

        def account_id
          ENV['AWS_ACCOUNT_ID']
        end

        def fifo_suffix
          @fifo ? "#{@suffix}.fifo" : @suffix
        end

        def validate!
          REQUIRED_ACCESSORS.each do |accessor_name|
            raise RequiredFieldError, "The field #{accessor_name} is required" if send(accessor_name).nil?
          end
        end
      end
    end
  end
end
