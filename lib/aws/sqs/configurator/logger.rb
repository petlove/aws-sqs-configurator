# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      module Logger
        class << self
          def info(message)
            puts log_info(message)
          end

          def error(message)
            puts log_error(message)
          end

          def log_info(message)
            log('INFO', message)
          end

          def log_error(message)
            log('ERROR', message)
          end

          private

          def log(severity_level, message)
            "[#{Time.now.iso8601}] [AWS::SQS::Configurator] #{severity_level} -- : #{message}"
          end
        end
      end
    end
  end
end
