# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Reader, type: :model do
  describe 'PATH' do
    subject { described_class::PATH }

    it 'should catch from config' do
      is_expected.to eq('./config/aws-sqs-configurator.yml')
    end
  end

  describe '#initialize' do
    before { stub_const("#{described_class}::PATH", "./spec/fixtures/configs/#{file}.yml") }

    context 'without file' do
      let(:file) { 'a' }

      it 'should set config as emtpy hash' do
        expect(subject.config).to eq(queues: [])
      end
    end

    context 'with empty config' do
      let(:file) { 'empty_config' }

      it 'should set config as emtpy hash' do
        expect(subject.config).to eq(queues: [])
      end
    end

    context 'without queues' do
      let(:file) { 'without_queues' }

      it 'should set config with default fields' do
        expect(subject.config).to eq(
          region: 'us-east-1',
          prefix: 'system_name',
          suffix: 'queue',
          environment: 'production',
          fifo: false,
          content_based_deduplication: false,
          max_receive_count: 7,
          dead_letter_queue: true,
          dead_letter_queue_suffix: 'failures',
          visibility_timeout: 60,
          message_retention_period: 1_209_600,
          queues: []
        )
      end
    end

    context 'with queues' do
      let(:file) { 'with_queues' }

      it 'should set config with default fields' do
        expect(subject.config).to eq(
          region: 'us-east-1',
          prefix: 'system_name',
          suffix: 'queue',
          environment: 'production',
          fifo: false,
          content_based_deduplication: false,
          max_receive_count: 7,
          dead_letter_queue: true,
          dead_letter_queue_suffix: 'failures',
          visibility_timeout: 60,
          message_retention_period: 1_209_600,
          queues: [
            {
              name: 'product_updater',
              region: 'sa-east-1',
              metadata: {
                type: 'strict',
                reference: 'product'
              },
              topics: [
                {
                  name: 'product',
                  region: 'sa-east-1'
                }
              ]
            },
            {
              name: 'product_adjuster',
              suffix: 'alert',
              dead_letter_queue: false
            }
          ]
        )
      end
    end
  end

  describe '#queues' do
    before { stub_const("#{described_class}::PATH", "./spec/fixtures/configs/#{file}.yml") }
    subject { described_class.new.queues! }

    context 'without file' do
      let(:file) { 'a' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with empty config' do
      let(:file) { 'empty_config' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'without queues' do
      let(:file) { 'without_queues' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with queues' do
      let(:file) { 'with_queues' }

      it 'should return 2 queues' do
        expect(subject.length).to eq(2)
      end

      it 'should return queues' do
        expect(subject.all? { |topic| topic.is_a?(AWS::SQS::Configurator::Queue) }).to be_truthy
      end
    end
  end
end
