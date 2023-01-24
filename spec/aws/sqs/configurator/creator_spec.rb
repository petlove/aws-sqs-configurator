# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Creator, type: :model do
  before do
    allow_any_instance_of(AWS::SQS::Configurator::Queue).to receive(:extract_existing_arns).and_return nil
  end

  describe '#initialize' do
    before { stub_const('AWS::SQS::Configurator::Reader::MAIN_FILE', './spec/fixtures/configs/aws-sqs-shoryuken.yml') }

    it 'should have created and found empty' do
      expect(subject.created).to be_empty
    end

    it 'should get topics' do
      expect(subject.queues.all? { |t| t.is_a?(AWS::SQS::Configurator::Queue) }).to be_truthy
    end
  end

  describe '#create!' do
    let(:instance) { described_class.new }
    subject { instance.create! }

    before { stub_const('AWS::SQS::Configurator::Reader::MAIN_FILE', "./spec/fixtures/configs/#{file}.yml") }

    context 'without dead letter queue' do
      context 'with an existent queue' do
        let(:file) { 'without_dead_letter_queue_with_an_existent_queue' }

        it 'should find zero times and create twice', :vcr do
          expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
          expect(instance).to receive(:create_queue).twice.and_call_original
          expect(subject.created.length).to eq(2)
        end
      end

      context 'without existent queue' do
        let(:file) { 'without_dead_letter_queue_without_existent_queue' }

        it 'should find zero times and create twice', :vcr do
          expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
          expect(instance).to receive(:create_queue).twice.and_call_original
          expect(subject.created.length).to eq(2)
        end
      end
    end

    context 'with dead letter queue' do
      context 'with an existent queue' do
        let(:file) { 'with_dead_letter_queue_with_an_existent_queue' }

        it 'should find zero times and create twice', :vcr do
          expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
          expect(instance).to receive(:create_queue).twice.and_call_original
          expect(subject.created.length).to eq(2)
        end
      end

      context 'without existent queue' do
        let(:file) { 'with_dead_letter_queue_without_existent_queue' }

        it 'should find zero times and create twice', :vcr do
          expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
          expect(instance).to receive(:create_queue).twice.and_call_original
          expect(subject.created.length).to eq(2)
        end
      end
    end
  end
end
