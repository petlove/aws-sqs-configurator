# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws/sqs/configurator/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws-sqs-configurator'
  spec.version       = AWS::SQS::Configurator::VERSION
  spec.authors       = ['linqueta']
  spec.email         = ['tecnologia@petlove.com.br']

  spec.licenses      = ['MIT']
  spec.summary       = 'Simple configurator for AWS SQS services'
  spec.description   = 'Simple configurator for AWS SQS services'
  spec.homepage      = 'https://github.com/petlove/aws-sqs-configurator'

  spec.files         = Dir['{lib}/**/*', 'CHANGELOG.md', 'MIT-LICENSE', 'README.md']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.2.10'

  spec.add_dependency 'aws-sdk-sqs', '~> 1.18.0'
  spec.add_dependency 'aws-sns-configurator', '~> 0.1.0'
  spec.add_dependency 'ruby-utils', '>= 0.1.0'

  spec.add_development_dependency 'bundler', '~> 1.17.3'
  spec.add_development_dependency 'rake', '~> 10.0'
end
