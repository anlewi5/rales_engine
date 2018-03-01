# Rails Engine

[![CircleCI](https://circleci.com/gh/anlewis/rails_engine.svg?style=sheild)](https://circleci.com/gh/anlewis/rails_engine)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Rails Engine](#rails-engine)
  - [About](#about)
  - [Getting Started](#getting-started)
  - [Testing](#testing)
  - [Schema](#schema)
  - [Contributers](#contributers)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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

To view the JSON API endpoint, visit the path, ending with .json. For example, visiting `http://localhost:3000/api/v1/merchants/random.json` returns a random merchant.

## JSON Endpoints

### Record Endpoints

For a given :resource (merchants, items, invoices, invoice_items, customers, transactions)...
  
* `GET /api/v1/:resource` returns a list of all instances of a resource
* `GET /api/v1/:resource/:id` returns a resource
* `GET /api/v1/:resource/find?<parameters>` returns a resource with the given (as params) attributes
* `GET /api/v1/:resource/find_all?<parameters>` returns a list of resources with the given (as params) attributes
* `GET /api/v1/:resource/random` returns a random instance of a resource

### Relationship Endpoints

#### Merchants
* `GET /api/v1/merchants/:id/items` returns a collection of items associated with that merchant
* `GET /api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders
#### Invoices
* `GET /api/v1/invoices/:id/transactions` returns a collection of associated transactions
* `GET /api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items
* `GET /api/v1/invoices/:id/items` returns a collection of associated items
* `GET /api/v1/invoices/:id/customer` returns the associated customer
* `GET /api/v1/invoices/:id/merchant` returns the associated merchant
#### Invoice Items
* `GET /api/v1/invoice_items/:id/invoice` returns the associated invoice
* `GET /api/v1/invoice_items/:id/item` returns the associated item
#### Items
* `GET /api/v1/items/:id/invoice_items` returns a collection of associated invoice items
* `GET /api/v1/items/:id/merchant` returns the associated merchant
#### Transactions
* `GET /api/v1/transactions/:id/invoice` returns the associated invoice
#### Customers
* `GET /api/v1/customers/:id/invoices` returns a collection of associated invoices
* `GET /api/v1/customers/:id/transactions` returns a collection of associated transactions

### Business Intelligence Endpoints

#### All Merchants
* `GET /api/v1/merchants/most_revenue?quantity=x` returns the top x merchants ranked by total revenue
* `GET /api/v1/merchants/most_items?quantity=x` returns the top x merchants ranked by total number of items sold
* `GET /api/v1/merchants/revenue?date=x returns` the total revenue for date x across all merchants
#### Single Merchant
* `GET /api/v1/merchants/:id/revenue` returns the total revenue for that merchant across successful transactions
* `GET /api/v1/merchants/:id/revenue?date=x` returns the total revenue for that merchant for a specific invoice date x
* `GET /api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions
#### Items
* `GET /api/v1/items/most_revenue?quantity=x` returns the top x items ranked by total revenue generated
* `GET /api/v1/items/most_items?quantity=x` returns the top x item instances ranked by total number sold
* `GET /api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
#### Customers
* `GET /api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions

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
