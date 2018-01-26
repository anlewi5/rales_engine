require 'rails_helper'

describe "customer relationships" do
  it "returns the associated invoices" do
    create(:customer, id: 1)
    create(:invoice, customer_id: 1)
    create(:invoice, customer_id: 1)

    get '/api/v1/customers/1/invoices'

    invoices = JSON.parse(response.body)
    invoice = invoices.first

    expect(response).to be_successful
    expect(invoices).to be_an(Array)
    expect(invoices.count).to eq 2
    expect(invoice).to have_key "status"
    expect(invoice).to have_key "merchant_id"
    expect(invoice).to have_key "customer_id"
  end

  it "returns associated transactions" do
    create(:customer, id: 1)
    create(:invoice, id: 1, customer_id: 1)
    create(:transaction, invoice_id: 1)
    create(:transaction, invoice_id: 1)

    get '/api/v1/customers/1/transactions'

    transactions = JSON.parse(response.body)
    transaction = transactions.first

    expect(response).to be_successful
    expect(transactions).to be_an(Array)
    expect(transactions.count).to eq 2
    expect(transaction).to have_key "result"
    expect(transaction).to have_key "credit_card_number"
    expect(transaction).to have_key "invoice_id"
    expect(transaction).not_to have_key "credit_card_expiration_date"
  end
end