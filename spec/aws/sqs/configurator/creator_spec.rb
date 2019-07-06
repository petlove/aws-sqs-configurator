# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Creator, type: :model do
  describe '#initialize' do
    before { stub_const('AWS::SQS::Configurator::Reader::PATH', './spec/fixtures/configs/aws-sqs-shoryuken.yml') }

    it 'should have created and found empty' do
      expect(subject.created).to be_empty
      expect(subject.found).to be_empty
    end

    it 'should get topics' do
      expect(subject.queues.all? { |t| t.is_a?(AWS::SQS::Configurator::Queue) }).to be_truthy
    end
  end

  describe '#create!' do
    let(:instance) { described_class.new(force) }
    subject { instance.create! }

    before { stub_const('AWS::SQS::Configurator::Reader::PATH', "./spec/fixtures/configs/#{file}.yml") }

    context 'default' do
      let(:force) { false }

      context 'without dead letter queue' do
        context 'with an existent queue' do
          let(:file) { 'default_without_dead_letter_queue_with_an_existent_queue' }

          it 'should find twice and create once', :vcr do
            expect(instance).to receive(:find_queue).twice.and_call_original
            expect(instance).to receive(:create_queue).once.and_call_original
            expect(subject.found.length).to eq(1)
            expect(subject.created.length).to eq(1)
          end
        end

        context 'without existent queue' do
          let(:file) { 'default_without_dead_letter_queue_without_existent_queue' }

          it 'should find twice and create twice', :vcr do
            expect(instance).to receive(:find_queue).twice.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end
      end

      context 'with dead letter queue' do
        context 'with an existent queue' do
          let(:file) { 'default_with_dead_letter_queue_with_an_existent_queue' }

          it 'should find twice and create once', :vcr do
            expect(instance).to receive(:find_queue).twice.and_call_original
            expect(instance).to receive(:create_queue).once.and_call_original
            expect(subject.found.length).to eq(1)
            expect(subject.created.length).to eq(1)
          end
        end

        context 'without existent queue' do
          let(:file) { 'default_with_dead_letter_queue_without_existent_queue' }

          it 'should find three times times and create twice', :vcr do
            expect(instance).to receive(:find_queue).exactly(3).times.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end
      end
    end

    context 'forced' do
      let(:force) { true }

      context 'without dead letter queue' do
        context 'with an existent queue' do
          let(:file) { 'forced_without_dead_letter_queue_with_an_existent_queue' }

          it 'should find zero times and create twice', :vcr do
            expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end

        context 'without existent queue' do
          let(:file) { 'forced_without_dead_letter_queue_without_existent_queue' }

          it 'should find zero times and create twice', :vcr do
            expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end
      end

      context 'with dead letter queue' do
        context 'with an existent queue' do
          let(:file) { 'forced_with_dead_letter_queue_with_an_existent_queue' }

          it 'should find zero times and create twice', :vcr do
            expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end

        context 'without existent queue' do
          let(:file) { 'forced_with_dead_letter_queue_without_existent_queue' }

          it 'should find zero times and create twice', :vcr do
            expect(instance).to receive(:find_queue).exactly(0).times.and_call_original
            expect(instance).to receive(:create_queue).twice.and_call_original
            expect(subject.found.length).to eq(0)
            expect(subject.created.length).to eq(2)
          end
        end
      end
    end
  end
end
