# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Reader, type: :model do
  describe 'MAIN_FILE' do
    subject { described_class::MAIN_FILE }

    it 'should catch from config' do
      is_expected.to eq('./config/aws-sqs-configurator.yml')
    end
  end

  describe 'DIR_FILES' do
    subject { described_class::DIR_FILES }

    it 'should catch from config' do
      is_expected.to eq('./config/aws-sqs-configurator/*')
    end
  end

  describe '#initialize' do
    before { stub_const("#{described_class}::MAIN_FILE", "./spec/fixtures/configs/#{file}.yml") }

    context 'without file' do
      let(:file) { 'a' }

      it 'should be a empty array' do
        expect(subject.packages.empty?).to be_truthy
      end
    end

    context 'with empty config' do
      let(:file) { 'empty_config' }

      it 'should be a empty array' do
        expect(subject.packages.empty?).to be_truthy
      end
    end

    context 'without topics' do
      let(:file) { 'without_queues' }

      it 'should have one instance of AWS::SQS::Configurator::Package' do
        expect(subject.packages.length).to eq(1)
        expect(subject.packages.first).to be_a(AWS::SQS::Configurator::Package)
      end

      it 'should have content without queues' do
        expect(subject.packages.first.content).to eq(
          default: {
            general: {
              content_based_deduplication: false,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'failures',
              environment: 'production',
              fifo: false,
              max_receive_count: 7,
              message_retention_period: 1_209_600,
              prefix: 'system_name',
              region: 'us-east-1',
              suffix: 'queue',
              visibility_timeout: 60
            }
          },
          queues: []
        )
      end
    end

    context 'with topics' do
      let(:file) { 'with_queues' }

      it 'should have one instance of AWS::SQS::Configurator::Package' do
        expect(subject.packages.length).to eq(1)
        expect(subject.packages.first).to be_a(AWS::SQS::Configurator::Package)
      end

      it 'should set config with default fields' do
        expect(subject.packages.first.content).to eq(
          default: {
            general: {
              content_based_deduplication: false,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'failures',
              environment: 'production',
              fifo: false,
              max_receive_count: 7,
              message_retention_period: 1_209_600,
              prefix: 'system_name',
              region: 'us-east-1',
              suffix: 'queue',
              visibility_timeout: 60
            }
          },
          queues: [
            {
              metadata: {
                reference: 'product',
                type: 'strict'
              },
              name: 'product_updater',
              region: 'sa-east-1',
              topics: [
                {
                  name: 'product',
                  region: 'sa-east-1'
                }
              ]
            },
            {
              dead_letter_queue: false,
              name: 'product_adjuster',
              suffix: 'alert'
            }
          ]
        )
      end
    end
  end

  describe '#read!' do
    before { stub_const("#{described_class}::MAIN_FILE", "./spec/fixtures/configs/#{file}.yml") }
    subject { described_class.new.read! }

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
        expect(subject.all? { |queue| queue.is_a?(AWS::SQS::Configurator::Queue) }).to be_truthy
      end
    end
  end
end
