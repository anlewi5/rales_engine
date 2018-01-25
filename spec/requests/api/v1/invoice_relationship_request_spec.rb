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

  it "returns a collection of associated invoice items" do 
    get "/api/v1/invoices/#{invoice.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items.first).to have_key("quantity")
  end

  it "returns a collection of associated items" do 
    get "/api/v1/invoices/#{invoice.id}/items"

    items =  JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.first).to have_key("name")
  end

  it "returns the associated customer" do 
    get "/api/v1/invoices/#{invoice.id}/customer"
   
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer).to have_key("first_name")
  end
  it "returns the associated merchant" do 
    get "/api/v1/invoices/#{invoice.id}/merchant"
    
    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant).to have_key("name")
  end

end