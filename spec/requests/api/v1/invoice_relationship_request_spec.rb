require 'rails_helper'

describe "invoice relationships" do 
  let!(:customer) { create(:customer) }
  let!(:merchant) { create(:merchant) }
  let!(:invoice) { create(:invoice, customer: customer, merchant: merchant) }
  let!(:item) { create(:item, merchant: merchant) }
  let!(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }
  let!(:transaction) { create(:transaction, invoice: invoice) }

  it "returns a collection of assoicated transactions" do 
    get "/api/v1/invoices/#{invoice.id}/transactions"

    invoice_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_transactions.class).to eq(Array)
    expect(invoice_transactions.first).to have_key("credit_card_number")
  end

end