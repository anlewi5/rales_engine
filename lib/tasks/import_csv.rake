require 'csv'

task :create_customers, [:customers] => :environment do
  CSV.foreach('db/csv/customers.csv', headers: true, header_converters: :symbol) do |row|
    Customer.create!(row.to_hash)
  end 
end

task :create_merchants, [:merchants] => :environment do
  CSV.foreach('db/csv/merchants.csv', headers: true, header_converters: :symbol) do |row|
    Merchant.create!(row.to_hash)
  end 
end

task :create_items, [:items] => :environment do
  CSV.foreach('db/csv/items.csv', headers: true, header_converters: :symbol) do |row|
    Item.create!(row.to_hash)
  end 
end

task :create_invoices, [:invoices] => :environment do
  CSV.foreach('db/csv/invoices.csv', headers: true, header_converters: :symbol) do |row|
    Invoice.create!(row.to_hash)
  end 
end

task :create_transactions, [:transactions] => :environment do
  CSV.foreach('db/csv/transactions.csv', headers: true, header_converters: :symbol) do |row|
    Transaction.create!(row.to_hash)
  end 
end

task :create_invoice_items, [:invoice_items] => :environment do
  CSV.foreach('db/csv/invoice_items.csv', headers: true, header_converters: :symbol) do |row|
    InvoiceItem.create!(row.to_hash)
  end 
end

task :import_csv do
  Rake::Task["create_customers"].invoke
  puts "added customers to database"
  Rake::Task["create_merchants"].invoke
  puts "added merchants to database"
  Rake::Task["create_items"].invoke
  puts "added items to database"
  Rake::Task["create_invoices"].invoke
  puts "added invoices to database"
  Rake::Task["create_transactions"].invoke
  puts "added transactions to database"
  Rake::Task["create_invoice_items"].invoke
  puts "added invoice_items to database"
end
