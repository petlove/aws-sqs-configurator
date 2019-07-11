# frozen_string_literal: true

RSpec.describe AWS::SQS::Configurator::Package, type: :model do
  describe '#initialize' do
    subject { described_class.new(content) }

    context 'with nil content' do
      let(:content) { nil }

      it 'should have content with empty queues array' do
        expect(subject.content).to eq(queues: [])
      end

      it 'should have empty queue options' do
        expect(subject.queues_options).to eq([])
      end

      it 'should have empty general default options' do
        expect(subject.general_default_options).to eq({})
      end

      it 'should have empty topic default options' do
        expect(subject.topic_default_options).to eq({})
      end

      it 'should have empty queue default options' do
        expect(subject.queue_default_options).to eq({})
      end
    end

    context 'with empty topics' do
      let(:content) { { queues: [] } }

      it 'should have content with empty queues array' do
        expect(subject.content).to eq(queues: [])
      end

      it 'should have empty queue options' do
        expect(subject.queues_options).to eq([])
      end

      it 'should have empty general default options' do
        expect(subject.general_default_options).to eq({})
      end

      it 'should have empty topic default options' do
        expect(subject.topic_default_options).to eq({})
      end

      it 'should have empty queue default options' do
        expect(subject.queue_default_options).to eq({})
      end
    end

    context 'with default options and topics' do
      let(:content) do
        {
          default: {
            general: {
              region: 'us-east-1',
              prefix: 'system_name',
              suffix: 'queue',
              environment: 'production',
              metadata: {
                priority: 1
              }
            },
            topic: {
              region: 'us-east-2',
              prefix: 'products',
              suffix: 'failures',
              environment: 'production',
              metadata: {
                priority: 2
              }
            },
            queue: {
              region: 'us-east-2',
              prefix: 'system_name-2',
              suffix: 'queue-2',
              environment: 'production-2',
              fifo: true,
              content_based_deduplication: true,
              max_receive_count: 6,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'error',
              visibility_timeout: 50,
              message_retention_period: 1_000_000,
              metadata: {
                priority: 3
              }
            }
          },
          queues: [
            {
              name: 'prices_update',
              region: 'us-east-2',
              topics: [{
                name: 'product'
              }]
            },
            {
              name: 'prices_adjuster',
              suffix: 'alert',
              region: 'sa-east-1'
            }
          ]
        }
      end

      it 'should have content' do
        expect(subject.content).to eq(
          default: {
            general: {
              region: 'us-east-1',
              prefix: 'system_name',
              suffix: 'queue',
              environment: 'production',
              metadata: {
                priority: 1
              }
            },
            topic: {
              region: 'us-east-2',
              prefix: 'products',
              suffix: 'failures',
              environment: 'production',
              metadata: {
                priority: 2
              }
            },
            queue: {
              region: 'us-east-2',
              prefix: 'system_name-2',
              suffix: 'queue-2',
              environment: 'production-2',
              fifo: true,
              content_based_deduplication: true,
              max_receive_count: 6,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'error',
              visibility_timeout: 50,
              message_retention_period: 1_000_000,
              metadata: {
                priority: 3
              }
            }
          },
          queues: [
            {
              name: 'prices_update',
              region: 'us-east-2',
              topics: [
                {
                  name: 'product'
                }
              ]
            },
            {
              name: 'prices_adjuster',
              suffix: 'alert',
              region: 'sa-east-1'
            }
          ]
        )
      end

      it 'should have queue options' do
        expect(subject.queues_options).to eq(
          [
            {
              name: 'prices_update',
              region: 'us-east-2',
              topics: [
                {
                  name: 'product'
                }
              ]
            },
            {
              name: 'prices_adjuster',
              suffix: 'alert',
              region: 'sa-east-1'
            }
          ]
        )
      end

      it 'should have general default options' do
        expect(subject.general_default_options).to eq(
          region: 'us-east-1',
          prefix: 'system_name',
          suffix: 'queue',
          environment: 'production',
          metadata: {
            priority: 1
          }
        )
      end

      it 'should have topic default options' do
        expect(subject.topic_default_options).to eq(
          environment: 'production',
          prefix: 'products',
          region: 'us-east-2',
          suffix: 'failures',
          metadata: {
            priority: 2
          }
        )
      end

      it 'should have queue default options' do
        expect(subject.queue_default_options).to eq(
          region: 'us-east-2',
          prefix: 'system_name-2',
          suffix: 'queue-2',
          environment: 'production-2',
          fifo: true,
          content_based_deduplication: true,
          max_receive_count: 6,
          dead_letter_queue: true,
          dead_letter_queue_suffix: 'error',
          visibility_timeout: 50,
          message_retention_period: 1_000_000,
          metadata: {
            priority: 3
          }
        )
      end
    end
  end

  describe '#unpack!' do
    subject { described_class.new(content).unpack! }

    context 'with empty topics options' do
      let(:content) { nil }

      it 'should return emtpy array' do
        is_expected.to eq([])
      end
    end

    context 'with topics options' do
      let(:content) do
        {
          queues: [
            {
              name: 'prices_update',
              region: 'us-east-2',
              topics: [
                {
                  name: 'product',
                  region: 'us-east-2'
                }
              ]
            },
            {
              name: 'prices_adjuster',
              suffix: 'alert',
              region: 'sa-east-1'
            }
          ]
        }
      end

      it 'should return two queues' do
        expect(subject.length).to eq(2)
        expect(subject.all? { |s| s.is_a?(AWS::SQS::Configurator::Queue) }).to be_truthy
      end

      it 'should have name and region' do
        expect(subject.first.name).to eq('prices_update')
        expect(subject.first.region).to eq('us-east-2')
      end

      it 'should have name, suffix and region' do
        expect(subject.first(2).last.name).to eq('prices_adjuster')
        expect(subject.first(2).last.suffix).to eq('alert')
        expect(subject.first(2).last.region).to eq('sa-east-1')
      end
    end

    context 'with general and topics options' do
      let(:content) do
        {
          default: {
            general: {
              region: 'us-east-1',
              prefix: 'system_name',
              suffix: 'queue',
              environment: 'production',
              fifo: false,
              content_based_deduplication: false,
              max_receive_count: 7,
              dead_letter_queue: false,
              dead_letter_queue_suffix: 'failures',
              visibility_timeout: 60,
              message_retention_period: 1_209_600,
              metadata: {
                priority: 1
              }
            }
          },
          queues: [
            {
              name: 'prices_update'
            }
          ]
        }
      end

      it 'should apply general default options' do
        expect(subject.first.name).to eq('prices_update')
        expect(subject.first.region).to eq('us-east-1')
        expect(subject.first.prefix).to eq('system_name')
        expect(subject.first.suffix).to eq('queue')
        expect(subject.first.environment).to eq('production')
        expect(subject.first.fifo).to be_falsey
        expect(subject.first.content_based_deduplication).to be_falsey
        expect(subject.first.max_receive_count).to eq(7)
        expect(subject.first.dead_letter_queue).to be_falsey
        expect(subject.first.dead_letter_queue_suffix).to eq('failures')
        expect(subject.first.visibility_timeout).to eq(60)
        expect(subject.first.message_retention_period).to eq(1_209_600)
        expect(subject.first.metadata).to eq(priority: 1)
      end
    end

    context 'with general, topic, queue and queues options' do
      let(:content) do
        {
          default: {
            general: {
              region: 'us-east-1',
              prefix: 'system_name',
              suffix: 'queue',
              environment: 'production',
              fifo: false,
              content_based_deduplication: false,
              max_receive_count: 7,
              dead_letter_queue: false,
              dead_letter_queue_suffix: 'failures',
              visibility_timeout: 60,
              message_retention_period: 1_209_600,
              metadata: {
                priority: 1
              }
            },
            topic: {
              region: 'us-east-2',
              prefix: 'products',
              suffix: 'failures',
              environment: 'production',
              metadata: {
                priority: 2
              }
            },
            queue: {
              region: 'us-east-2',
              prefix: 'system_name-2',
              suffix: 'queue-2',
              environment: 'production-2',
              fifo: true,
              content_based_deduplication: true,
              max_receive_count: 6,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'error',
              visibility_timeout: 50,
              message_retention_period: 1_000_000,
              metadata: {
                priority: 3
              }
            }
          },
          queues: [
            {
              name: 'prices_update',
              topics: [
                {
                  name: 'product'
                }
              ]
            }
          ]
        }
      end

      it 'should apply general default options' do
        expect(subject.first.name).to eq('prices_update')
        expect(subject.first.region).to eq('us-east-2')
        expect(subject.first.prefix).to eq('system_name-2')
        expect(subject.first.suffix).to eq('queue-2')
        expect(subject.first.environment).to eq('production-2')
        expect(subject.first.fifo).to be_truthy
        expect(subject.first.content_based_deduplication).to be_truthy
        expect(subject.first.max_receive_count).to eq(6)
        expect(subject.first.dead_letter_queue).to be_truthy
        expect(subject.first.dead_letter_queue_suffix).to eq('error')
        expect(subject.first.visibility_timeout).to eq(50)
        expect(subject.first.message_retention_period).to eq(1_000_000)
        expect(subject.first.metadata).to eq(priority: 3)
      end
    end

    context 'with general, topic, queue and full queue options' do
      let(:content) do
        {
          default: {
            general: {
              region: 'us-east-1',
              prefix: 'system_name',
              suffix: 'queue',
              environment: 'production',
              fifo: false,
              content_based_deduplication: false,
              max_receive_count: 7,
              dead_letter_queue: false,
              dead_letter_queue_suffix: 'failures',
              visibility_timeout: 60,
              message_retention_period: 1_209_600,
              metadata: {
                priority: 1
              }
            },
            topic: {
              region: 'us-east-2',
              prefix: 'products',
              suffix: 'failures',
              environment: 'production',
              metadata: {
                priority: 2
              }
            },
            queue: {
              region: 'us-east-2',
              prefix: 'system_name-2',
              suffix: 'queue-2',
              environment: 'production-2',
              fifo: true,
              content_based_deduplication: true,
              max_receive_count: 6,
              dead_letter_queue: true,
              dead_letter_queue_suffix: 'error',
              visibility_timeout: 50,
              message_retention_period: 1_000_000,
              metadata: {
                priority: 3
              }
            }
          },
          queues: [
            {
              name: 'prices_update-3',
              region: 'us-east-3',
              prefix: 'system_name-3',
              suffix: 'queue-3',
              environment: 'production-3',
              fifo: false,
              content_based_deduplication: false,
              max_receive_count: 2,
              dead_letter_queue: false,
              dead_letter_queue_suffix: 'warning',
              visibility_timeout: 40,
              message_retention_period: 10,
              metadata: {
                priority: 4
              },
              topics: [
                {
                  name: 'product'
                }
              ]
            }
          ]
        }
      end

      it 'should apply general default options' do
        expect(subject.first.name).to eq('prices_update-3')
        expect(subject.first.region).to eq('us-east-3')
        expect(subject.first.prefix).to eq('system_name-3')
        expect(subject.first.suffix).to eq('queue-3')
        expect(subject.first.environment).to eq('production-3')
        expect(subject.first.fifo).to be_falsey
        expect(subject.first.content_based_deduplication).to be_falsey
        expect(subject.first.max_receive_count).to eq(2)
        expect(subject.first.dead_letter_queue).to be_falsey
        expect(subject.first.dead_letter_queue_suffix).to eq('warning')
        expect(subject.first.visibility_timeout).to eq(40)
        expect(subject.first.message_retention_period).to eq(10)
        expect(subject.first.metadata).to eq(priority: 4)
      end
    end
  end
end
