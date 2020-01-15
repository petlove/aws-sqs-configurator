# frozen_string_literal: true

module AWS
  module SQS
    module Configurator
      module Logger
        LOGGER_ENABLED_ENV = 'AWS_SQS_CONFIGURATOR_LOGGER'

        class << self
          def info(message)
            puts log_info(message) if log?
          end

          def error(message)
            puts log_error(message) if log?
          end

          def log_info(message)
            log('INFO', message)
          end

          def log_error(message)
            log('ERROR', message)
          end

          private

          def log?
            ENV[LOGGER_ENABLED_ENV] != 'false'
          end

          def log(severity_level, message)
            "[#{Time.now.iso8601}] [AWS::SQS::Configurator] #{severity_level} -- : #{message}"
          end
        end
      end
    end
  end
end
