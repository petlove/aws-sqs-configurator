# [AWS::SQS::Configurator](https://github.com/petlove/aws-sqs-configurator)

[![Build Status](https://travis-ci.org/petlove/aws-sqs-configurator.svg?branch=master)](https://travis-ci.org/petlove/aws-sns-configurator)
[![Maintainability](https://api.codeclimate.com/v1/badges/62a68418dca81785bfa3/maintainability)](https://codeclimate.com/github/petlove/aws-sqs-configurator/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/62a68418dca81785bfa3/test_coverage)](https://codeclimate.com/github/petlove/aws-sqs-configurator/test_coverage)

Simple configuration to create queues, topics and subscriptions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-sqs-configurator'
```
or the latest version:

```ruby
gem 'aws-sqs-configurator', github: 'petlove/aws-sqs-configurator'
```

## Usage

### Configuration
Set the config in _/config/aws-sqs-configurator.yml_ like this:
```yml
---
region: 'us-east-1'
prefix: 'system_name'
suffix: 'queue'
environment: 'production'
failures: true
queues:
  - name: 'product_updater'
    region: 'sa-east-1'
    topics:
        - name: 'product'
          region: 'sa-east-1'
  - name: 'product_adjuster'
    suffix: 'alert'
    failures: false
```

Out of topics list, you should define default options that won't be required in the topic options. The available options are:

| Name | Default | Required | What's it |
|------|---------|----------|-----------|
| `region` | `nil` | yes | The AWS region. |
| `prefix` | `nil` | no | The queue name prefix. It's inserted before the `environment`.|
| `suffix` | `nil` | no | The queue name suffix. It's inserted after the `name`. |
| `environment` | `nil` | no | The queue environment. It's inserted between `prefix` and `name`. |
| `failures` | `false` | no | If the queue has a failures queue. If yes, will be created another queue with the suffix "_failures". |
| `queues` | `[]` | yes | The queues list. |
| `name` | `nil` | yes | The queue or topic name. |
| `topics` | `[]` | no | The topics that the queue will subscribe. |

### Environments

You should declare these environments to this gem works as well:
* `AWS_ACCOUNT_ID`: It's your AWS account id
* `AWS_ACCESS_KEY_ID`: It's your AWS access key
* `AWS_SECRET_KEY`: It's your AWS secret key

#### Tasks

If you are using [Ruby on Rails](https://github.com/rails/rails), you could use this rake task:
```bash
rake sqs:create
```

Output:
```bash
```

You could pass the option "force" to create them without check if they exist.

#### Create

You could create topics using this code:

```ruby
AWS::SQS::Configurator.create!
```

or if you would like to force:

```ruby
AWS::SQS::Configurator.create!(true)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petlove/aws-sns-configurator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
