require 'rails_helper'

describe "transaction relationships" do
  it "returns a collection of associated invoices" do
    create(:transaction, id: 1)
    create(:invoice, transaction_id: 1)
    create(:invoice, transaction_id: 1)

    get '/api/v1/transations/1/invoice'

    invoices = JSON.parse(response.body)
    invoice = invoices.first

    expect(response).to be_successful
    expect(invoices).to be_an(Array)
    expect(invoices.count).to eq 3
    expect(invoice).to have_key "status"
    expect(invoice).to have_key "merchant_id"
    expect(invoice).to have_key "customer_id"
  end
end