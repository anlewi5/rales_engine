require 'rails_helper'

describe "transaction relationships" do
  it "returns the associated invoice" do
    create(:invoice, id: 1)
    create(:transaction, id: 1, invoice_id: 1)

    get '/api/v1/transactions/1/invoice'

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice).to have_key "status"
    expect(invoice).to have_key "merchant_id"
    expect(invoice).to have_key "customer_id"
  end
end