require 'rails_helper'

describe "invoice items relationships" do 
  let!(:customer) { create(:customer) }
  let!(:merchant) { create(:merchant) }
  let!(:invoice) { create(:invoice, customer: customer, merchant: merchant) }
  let!(:item) { create(:item, merchant: merchant) }
  let!(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }

  it "returns the associated invoice" do 
    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice).to have_key("status")
  end
  it "returns the associated item" do 
    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(item).to have_key("name")
  end
end