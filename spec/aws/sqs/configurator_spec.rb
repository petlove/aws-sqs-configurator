# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator do
  it 'has a version number' do
    expect(AWS::SQS::Configurator::VERSION).not_to be nil
  end

  describe '#read!' do
    subject { described_class.read! }

    after { subject }

    it 'should use reader to get queues' do
      expect_any_instance_of(described_class::Reader).to receive(:queues!)
    end
  end

  describe '#create!' do
    subject { described_class.create!(force) }

    after { subject }

    context 'default' do
      let(:force) { false }

      it 'should use the class Creator to create the topics' do
        expect_any_instance_of(described_class::Creator).to receive(:initialize).once
        expect_any_instance_of(described_class::Creator).to receive(:create!).once
      end
    end

    context 'forced' do
      let(:force) { true }

      it 'should use the class Creator to create the topics' do
        expect_any_instance_of(described_class::Creator).to receive(:initialize).once
        expect_any_instance_of(described_class::Creator).to receive(:create!).once
      end
    end
  end
end
