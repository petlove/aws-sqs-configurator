# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }


gem 'aws-sdk-sqs', '~> 1.18.0'
gem 'aws-sns-configurator', github: 'petlove/aws-sns-configurator'

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :test do
  gem 'factory_bot'
  gem 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0']
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'simplecov-console'
  gem 'simplecov-summary'
  gem 'vcr'
  gem 'webmock'
end

gemspec
