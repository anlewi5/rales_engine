# Rails Engine

[![CircleCI](https://circleci.com/gh/anlewi5/rales_engine/tree/master.svg?style=shield)](https://circleci.com/gh/anlewi5/rales_engine/tree/master)

## About

The purpose of this project is to use Rails and ActiveRecord to build a JSON API which exposes the [SalesEngine data schema](https://github.com/turingschool-examples/sales_engine/tree/master/data).

## Getting Started

This project uses the Ruby on Rails framework, which can be installed from [here](http://installrails.com/).
[Bundler](http://bundler.io/) is used to install the gems needed for this application.

In order to run this appication in the development environment, perform the following in the CLI:

```
bundle install
rake db:create db:migrate
rake import_csv
```

In order to spin-up the server, run: `rails s`

## Testing

[Rspec-Rails](https://github.com/rspec/rspec-rails) is used for testing.
[Factory_Bot](https://github.com/thoughtbot/factory_bot) is used to create test data.

In order to run tests, perform the following:

`rake db:test:prepare`

`rspec`

## Schema
![schema](https://image.ibb.co/dUhr9G/Screen_Shot_2018_01_24_at_16_36_00.png)


## Contributers

Anna Lewis (@anlewi5) Nico Lewis(@nico24687)
