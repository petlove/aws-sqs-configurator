# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator do
  it 'has a version number' do
    expect(AWS::SQS::Configurator::VERSION).not_to be nil
  end

  describe '#queues!' do
    subject { described_class.queues! }

    after { subject }

    it 'should use reader to get queues' do
      expect_any_instance_of(described_class::Reader).to receive(:read!)
    end
  end

  describe '#create!' do
    subject { described_class.create! }

    after { subject }

    it 'should use the class Creator to create the topics' do
      expect_any_instance_of(described_class::Creator).to receive(:initialize).once
      expect_any_instance_of(described_class::Creator).to receive(:create!).once
    end
  end
end
