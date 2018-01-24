require 'rails_helper'

describe "Item relationships" do 

    let!(:customer)     { create(:customer) }
    let!(:merchant)     { create(:merchant) }
    let!(:invoice)      { create(:invoice, merchant: merchant, customer: customer) }
    let!(:item)         { create(:item) }
    let!(:invoice_item) { create(:invoice_item, invoice: invoice, item: item) }
    let!(:transaction)  { create(:transaction, invoice: invoice) }

  it "returns a collection of associated invoice items" do 

    get "/api/v1/items/#{item.id}/invoice_items" 
    item = JSON.parse(response.body)

    expect(item.first).to have_key("id")
    expect(item.first).to have_key("quantity")
    expect(item.class).to eq(Array)
  end
end