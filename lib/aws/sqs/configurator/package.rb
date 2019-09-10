# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      class Package
        GENERAL_DEFAULT_OPTIONS = %i[region prefix suffix environment metadata].freeze
        TOPIC_DEFAULT_OPTIONS = %i[region prefix suffix environment metadata].freeze
        QUEUE_DEFAULT_OPTIONS = %i[region prefix suffix environment visibility_timeout max_receive_count
                                   message_retention_period fifo dead_letter_queue dead_letter_queue_suffix
                                   content_based_deduplication metadata].freeze
        GENERAL_DEFAULT_PATH = %i[default general].freeze
        TOPIC_DEFAULT_PATH = %i[default topic].freeze
        QUEUE_DEFAULT_PATH = %i[default queue].freeze
        DEFAULT_CONTENT = { queues: [] }.freeze

        attr_accessor :content, :queues_options, :general_default_options, :topic_default_options,
                      :queue_default_options

        def initialize(content)
          build_content!(content)
          build_queues_options!
          build_general_default_options!
          build_topic_default_options!
          build_queue_default_options!
        end

        def unpack!
          @queues_options.map(&method(:build_queue!))
        end

        private

        def build_content!(content)
          @content = DEFAULT_CONTENT.merge(content || {})
        end

        def build_queues_options!
          @queues_options = @content[:queues]
        end

        def build_general_default_options!
          @general_default_options = default_options(GENERAL_DEFAULT_PATH, GENERAL_DEFAULT_OPTIONS)
        end

        def build_topic_default_options!
          @topic_default_options = default_options(TOPIC_DEFAULT_PATH, TOPIC_DEFAULT_OPTIONS)
        end

        def build_queue_default_options!
          @queue_default_options = default_options(QUEUE_DEFAULT_PATH, QUEUE_DEFAULT_OPTIONS)
        end

        def default_options(path, fields)
          (@content&.dig(*path) || {}).slice(*fields)
        end

        def build_queue!(queue_options)
          Queue.new(build_queue_options(queue_options))
        end

        def build_queue_options(queue_options)
          merge_queue_options(queue_options).tap { |queue| queue[:topics] = build_topics_options(queue[:topics]) }
        end

        def build_topics_options(topics)
          topics ? topics.map(&method(:build_topic_options)) : []
        end

        def build_topic_options(topic)
          @general_default_options.merge(@topic_default_options).merge(topic)
        end

        def merge_queue_options(queue_options)
          @general_default_options.merge(@queue_default_options).merge(queue_options.compact)
        end
      end
    end
  end
end
