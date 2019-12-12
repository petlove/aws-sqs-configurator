# frozen_string_literal: true

require 'yaml'
require 'erb'

module AWS
  module SQS
    module Configurator
      class Reader
        MAIN_FILE = './config/aws-sqs-configurator.yml'
        DIR_FILES = './config/aws-sqs-configurator/*'

        attr_accessor :packages

        def initialize
          build_packages!
        end

        def read!
          all_queues = @packages.flat_map(&:unpack!).group_by(&:arn).map do |_arn, queues|
            topics = queues.map(&:topics).flatten.sort_by(&:arn).uniq
            queues.each { |queue| queue.topics = topics }
          end.flatten
          validate_queue_conflicts(all_queues)
          all_queues.uniq(&:to_json)
        end

        private

        def validate_queue_conflicts(queues)
          uniq_queues = queues.uniq(&:to_json)
          return if uniq_queues.length == uniq_queues.map(&:arn).uniq.length

          uniq_queues.group_by(&:arn).each do |k, v|
            puts "Conflicting configuration found for #{k}" if v.length > 1
          end
          raise
        end

        def file_names
          Dir[DIR_FILES] << MAIN_FILE
        end

        def build_packages!
          @packages = file_names.each_with_object([], &method(:append_package!))
        end

        def append_package!(file_name, list)
          content = content!(file_name)
          return unless content

          list << Package.new(content)
        end

        def read_file!(file_name)
          File.read(file_name)
        rescue Errno::ENOENT
          nil
        end

        def handle_environments(file)
          ERB.new(file).result if file
        end

        def symbolize_content(content)
          JSON.parse(content.to_json, symbolize_names: true) if content
        end

        def load_yml(file)
          YAML.safe_load(file) if file
        end

        def content!(file_name)
          symbolize_content(load_yml(handle_environments(read_file!(file_name))))
        end
      end
    end
  end
end
