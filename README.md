# SplitDateTime

[![Code Climate](https://codeclimate.com/github/ccallebs/split_date_time.png)](https://codeclimate.com/github/ccallebs/split_date_time)
[![Code Climate](https://codeclimate.com/github/ccallebs/split_date_time/coverage.png)](https://codeclimate.com/github/ccallebs/split_date_time)

A simple gem that allows you to split a DateTime field into a Date and a Time field for separate processing.

## Installation

Add this line to your application's Gemfile:

    gem 'split_date_time'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install split_date_time

## Usage

In your ActiveRecord model:

```
split_date_time field: 'created_at', prefix: 'created'
```
**field** (required): The table column you'd like to split.

**prefix** (optional): A custom prefix to use.

The above would generate the following methods:

- `created_date`
- `created_date=`
- `created_time`
- `created_time=`

You'll then be able to use these as you would any other ActiveRecord attribute. The fields will be concatenated and stored as a DateTime when you save the model.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
