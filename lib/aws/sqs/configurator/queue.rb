# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Queue
        class RequiredFieldError < StandardError; end

        attr_accessor :name, :region, :prefix, :suffix, :environment, :metadata, :name_formatted, :arn, :topics,
                      :visibility_timeout, :max_receive_count, :message_retention_period, :fifo, :dead_letter_queue,
                      :dead_letter_queue_suffix, :content_based_deduplication, :attributes, :dead_letter

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

          build_accessors_by_options!(options)
          build_name_formatted!
          build_arn!
          build_topics!(options[:topics])
          build_dead_letter!(options)
          build_attributes!

          validate!
        end

        def create!(client)
          client.aws.create_queue(queue_name: @name_formatted, attributes: @attributes)
        end

        private

        def build_accessors_by_options!(options)
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
        end

        def build_dead_letter!(options)
          @dead_letter = self.class.new(dead_letter_options(options)) if @dead_letter_queue
        end

        def dead_letter_options(options)
          options.merge(dead_letter_queue: false, suffix: [@suffix, @dead_letter_queue_suffix].compact.join('_'))
        end

        def build_attributes!
          @attributes = {
            FifoQueue: fifo_queue_attribute,
            ContentBasedDeduplication: content_based_deduplication_attribute,
            VisibilityTimeout: @visibility_timeout.to_s,
            MessageRetentionPeriod: @message_retention_period.to_s,
            maxReceiveCount: max_receive_count_attribute,
            deadLetterTargetArn: dead_letter_target_arn_attribute
          }.reject { |_key, value| value.nil? }
        end

        def fifo_queue_attribute
          'true' if @fifo
        end

        def content_based_deduplication_attribute
          @content_based_deduplication.to_s if @fifo
        end

        def dead_letter_target_arn_attribute
          @dead_letter.arn if @dead_letter_queue
        end

        def max_receive_count_attribute
          @max_receive_count.to_s if @dead_letter_queue
        end

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
          @name_formatted = [[@prefix, @environment, @name, @suffix].compact.join('_'), fifo_suffix].compact.join('.')
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
          'fifo' if @fifo
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
