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
end
