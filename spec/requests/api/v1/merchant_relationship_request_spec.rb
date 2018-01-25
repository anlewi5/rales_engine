require 'rails_helper'

describe "merchant relationships" do
  it "returns the associated items" do
    create(:merchant, id: 1)
    create(:item, merchant_id: 1)
    create(:item, merchant_id: 1)

    get '/api/v1/merchants/1/items'

    items = JSON.parse(response.body)
    item = items.first

    expect(response).to be_successful
    expect(items).to be_an(Array)
    expect(items.count).to eq 2
    expect(item).to have_key "name"
    expect(item).to have_key "description"
    expect(item).to have_key "unit_price"
    expect(item).to have_key "merchant_id"
  end
# GET /api/v1/merchants/:id/invoices returns a collection of invoices associated with that merchant from their known orders
# what does 'known orders' mean?
  it "returns the associated invoices from a merchants known orders" do
    create(:merchant, id: 1)
    create(:invoice, merchant_id: 1)
    create(:invoice, merchant_id: 1)

    get '/api/v1/merchants/1/invoices'

    invoices = JSON.parse(response.body)
    invoice = invoices.first

    expect(response).to be_successful
    expect(invoices).to be_an(Array)
    expect(invoices.count).to eq 2
    expect(invoice).to have_key "status"
    expect(invoice).to have_key "merchant_id"
    expect(invoice).to have_key "customer_id"
  end
end