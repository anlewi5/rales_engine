FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity Faker::Number.between(1,10)
    unit_price Faker::Number.between(1,10000)
  end
end
