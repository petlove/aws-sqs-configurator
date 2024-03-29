# [AWS::SQS::Configurator](https://github.com/petlove/aws-sqs-configurator)

[![Run specs](https://github.com/petlove/aws-sqs-configurator/actions/workflows/specs.yml/badge.svg)](https://github.com/petlove/aws-sqs-configurator/actions/workflows/specs.yml)

Simple configuration to create queues, topics and subscriptions (through [AWS::SNS::Configurator](https://github.com/petlove/aws-sns-configurator)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-sqs-configurator', github: 'petlove/aws-sqs-configurator'
```

## Usage

### Configuration
Set the config in _/config/aws-sqs-configurator.yml_ like this:
```yml
---
default:
  general:
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'topic'
    environment: 'production'
    metadata:
      type: Square
  queue:
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'queue'
    environment: 'production'
    fifo: false
    content_based_deduplication: false
    max_receive_count: 7
    dead_letter_queue: true
    dead_letter_queue_suffix: 'failures'
    visibility_timeout: 60
    message_retention_period: 1209600
    metadata:
      type: Hexagon
  topic:
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'topic'
    environment: 'production'
    metadata:
      type: Triangle
queues:
  - name: 'product_updater'
    region: 'us-east-1'
    prefix: 'system_name'
    suffix: 'queue'
    environment: 'production'
    fifo: false
    content_based_deduplication: false
    max_receive_count: 7
    dead_letter_queue: true
    dead_letter_queue_suffix: 'failures'
    visibility_timeout: 60
    message_retention_period: 1209600
    metadata:
      type: Circle
    topics:
        - name: 'product'
          region: 'sa-east-1'
          prefix: 'system_name'
          suffix: 'topic'
          environment: 'production'
          metadata:
            type: Another object
```
| Name | Default | Required | What's it |
|------|---------|----------|-----------|
| `default` | `nil` | false | The default values. It allows `general` and `topic`. |
| `general` | `nil` | false | The general default values. It allows `region`, `prefix`, `suffix`, `environment` and `metadata`. |
| `topic` | `nil` | false | The topic default values. The values overwrite `general` values. It allows `region`, `prefix`, `suffix`, `environment` and `metadata`. |
| `queue` | `nil` | false | The topic default values. The values overwrite `general` values. It allows `region`, `prefix`, `suffix`, `environment`, `fifo`, `content_based_deduplication`, `max_receive_count`, `dead_letter_queue`, `dead_letter_queue_suffix`, `visibility_timeout`, `message_retention_period` and `metadata`. |
| `queues` | `[]` | yes | The queues list. |
| `name` | `nil` | yes | The queue/topic name. |
| `region` | `nil` | yes | The AWS region. |
| `prefix` | `nil` | no | The queue name prefix. It's inserted before the `environment`.|
| `suffix` | `nil` | no | The queue name suffix. It's inserted after the `name`. |
| `environment` | `nil` | no | The queue/topic environment. It's inserted between `prefix` and `name`. |
| `fifo` | `false` | no | If the queue is a fifo queue. If true, will be added after the suffix the value `'.fifo'`. |
| `content_based_deduplication` | `false` | no | This instructs Amazon SQS to use a SHA-256 hash to generate the message deduplication ID using the body of the message. See more [here](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/FIFO-queues.html#FIFO-queues-exactly-once-processing) |
| `max_receive_count` | `7` | no | The maximum number of times that a message can be received by consumers. When this value is exceeded for a message the message will be automatically sent to the Dead Letter Queue if that exist. See more [here](https://aws.amazon.com/blogs/aws/amazon-sqs-new-dead-letter-queue/).|
| `dead_letter_queue` | `false` | no | If will generate a dead letter queue to hold failures. See more [here](https://aws.amazon.com/blogs/aws/amazon-sqs-new-dead-letter-queue/).|
| `dead_letter_queue_suffix` | `'_failures'` | no | The dead letter queue suffix. |
| `visibility_timeout` | `60` | no | The queue visibility timeout in seconds. See more [here](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-visibility-timeout.html).|
| `message_retention_period` | `1209600` | no | The queue message retention period in seconds. See more [here](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-basic-architecture.html).|
| `metadata` | `{}` | no | Any data that you want put inside the queue to identify it after read the config. |
| `topics` | `[]` | no | The topics that the queue will be subscribed. |

### Environments

You should declare these environments to this gem works as well:
* `AWS_ACCOUNT_ID`: It's your AWS account id
* `AWS_ACCESS_KEY_ID`: It's your AWS access key
* `AWS_SECRET_KEY`: It's your AWS secret key

#### Tasks

If you are using [Ruby on Rails](https://github.com/rails/rails), you could use this rake task:
```bash
rake aws:sqs:create
```

Output:
```bash
[2019-07-06T12:51:51-03:00] [AWS::SNS::Configurator] INFO -- : Found: product - sa-east-1
[2019-07-06T12:51:51-03:00] [AWS::SNS::Configurator] INFO -- : Subscribed: arn:aws:sqs:sa-east-1:381158256258:system_name_production_product_updater_9_queue -> product - sa-east-1
[2019-07-06T12:51:51-03:00] [AWS::SQS::Configurator] INFO -- : Added policy: ["subscription_in_product"]
[2019-07-06T12:51:51-03:00] [AWS::SQS::Configurator] INFO -- : Created: system_name_production_product_updater_9_queue - sa-east-1
[2019-07-06T12:51:51-03:00] [AWS::SQS::Configurator] INFO -- : Created: system_name_production_product_adjuster_9_alert - us-east-1
```

#### Create

You could create topics using this code:

```ruby
AWS::SQS::Configurator.create!
```

#### Get queues by config

You could get the topics in the config using this code:
```ruby
AWS::SQS::Configurator.queues!
```

#### Logging

AWS::SQS:Configurator logs all the queues created in SQS by default. If you want to disable it you can pass `AWS_SQS_CONFIGURATOR_LOGGER=false` before running it.
```bash
AWS_SQS_CONFIGURATOR_LOGGER=false rake aws:sqs:create
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petlove/aws-sns-configurator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
