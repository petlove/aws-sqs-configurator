# frozen_string_literal: true

FactoryBot.define do
  factory :queue, class: AWS::SQS::Configurator::Queue do
    initialize_with { new(name: 'update_price', region: 'us-east-1') }

    name { 'update_price' }
    region { 'us-east-1' }
    prefix { 'prices' }
    suffix { 'warning' }
    environment { 'production' }
    metadata { { type: 'strict' } }
    fifo { false }
    content_based_deduplication { false }
    max_receive_count { 7 }
    dead_letter_queue { true }
    dead_letter_queue_suffix { 'failures' }
    visibility_timeout { 60 }
    message_retention_period { 1_209_600 }
  end
end
