# Catlass

Cloud Automation as Code with [Cloud Automator](https://cloudautomator.com/en/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'catlass'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install catlass

## Usage

### Comands

```shell
$ catlass
Commands:
  catlass apply           # Apply the job definication
  catlass export          # Export the job definication
  catlass help [COMMAND]  # Describe available commands or one specific command

Options:
  -f, [--file=FILE]            # Job definication file
                               # Default: CAfile
      [--color], [--no-color]  # Disable colorize
                               # Default: true
```

#### apply
Apply the job definication

```shell
$ catlass help apply
Usage:
  catlass apply

Options:
      [--dry-run], [--no-dry-run]  # Dry run (Only output the difference)
  -f, [--file=FILE]                # Job definication file
                                   # Default: CAfile
      [--color], [--no-color]      # Disable colorize
                                   # Default: true
```

#### export
Export the job definication

```
$ catlass help export

Usage:
  catlass export

Options:
      [--write], [--no-write]  # Write the job definication to the file
      [--split], [--no-split]  # Split file by the jobs
  -f, [--file=FILE]            # Job definication file
                               # Default: CAfile
      [--color], [--no-color]  # Disable colorize
                               # Default: true
```

### Job definication file

```rb
Job "Auto Stop" do
  type "trigger_jobs"
  attributes do
    aws_account_id 999
    rule_type "cron"
    rule_value do
      hour "19"
      minutes "0"
      time_zone "Tokyo"
      schedule_type "weekly"
      weekly_schedule "", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"
      national_holiday_schedule "false"
    end
    action_type "stop_instances"
    action_value do
      region "ap-northeast-1"
      tag_key "auto-stop"
      tag_value "on"
      trace_status "false"
      specify_instance "tag"
    end
    active false
  end

end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcy-terui/catlass. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Catlass project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/marcy-terui/catlass/blob/master/CODE_OF_CONDUCT.md).
