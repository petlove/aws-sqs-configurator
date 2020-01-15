# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Logger, type: :module do
  describe '#log_info' do
    subject { described_class.log_info('The topic was created successfully') }

    it 'should be an info' do
      is_expected.to match(/INFO/)
    end

    it 'should have the project name' do
      is_expected.to match(/[AWS::SNS::Configurator]/)
    end

    it 'should have the message' do
      is_expected.to match(/The topic was created successfully/)
    end
  end

  describe '#log_error' do
    subject { described_class.log_error('The topic had an error') }

    it 'should be an error' do
      is_expected.to match(/ERROR/)
    end

    it 'should have the project name' do
      is_expected.to match(/[AWS::SNS:Configurator]/)
    end

    it 'should have the message' do
      is_expected.to match(/The topic had an error/)
    end
  end

  describe '#info' do
    subject { described_class.info('The topic was created successfully') }

    after { subject }

    context 'when AWS_SQS_CONFIGURATOR_LOGGER is not set' do
      before do
        allow(ENV).to receive(:[]).with(described_class::LOGGER_ENABLED_ENV).and_return(nil)
      end

      it 'should call log_info' do
        expect(described_class).to receive(:log_info)
          .with('The topic was created successfully').once
      end

      it 'should print with puts' do
        expect(described_class).to receive(:puts).once
      end
    end

    context 'when AWS_SQS_CONFIGURATOR_LOGGER is set to false' do
      before do
        allow(ENV).to receive(:[]).with(described_class::LOGGER_ENABLED_ENV).and_return('false')
      end

      it 'shouldnt call log_info' do
        expect(described_class).to_not receive(:log_info)
      end

      it 'shouldnt print with puts' do
        expect(described_class).to_not receive(:puts)
      end
    end
  end

  describe '#error' do
    subject { described_class.error('The topic had an error') }

    after { subject }

    context 'when AWS_SQS_CONFIGURATOR_LOGGER is not set' do
      before do
        allow(ENV).to receive(:[]).with(described_class::LOGGER_ENABLED_ENV).and_return(nil)
      end

      it 'should call log_info' do
        expect(described_class).to receive(:log_error)
          .with('The topic had an error').once
      end

      it 'should print with puts' do
        expect(described_class).to receive(:puts).once
      end
    end

    context 'when AWS_SQS_CONFIGURATOR_LOGGER is set to false' do
      before do
        allow(ENV).to receive(:[]).with(described_class::LOGGER_ENABLED_ENV).and_return('false')
      end

      it 'shouldnt call log_info' do
        expect(described_class).to_not receive(:log_error)
      end

      it 'shouldnt print with puts' do
        expect(described_class).to_not receive(:puts)
      end
    end
  end
end
