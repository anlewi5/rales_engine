require 'rails_helper'

describe "merchants API" do
  context "get request" do 
    it "returns a list of all merchants" do 
      merchants = create_list(:merchant, 3)
    
      get '/api/v1/merchants'

      expect(response).to be_successful 
      merchants = JSON.parse(response.body)
      expect(merchants.count).to eq(3)

    end
    it "can get a single merchant from id" do 
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end
    it "can get a random merchant" do 
      create(:merchant, id: 1)
      create(:merchant, id: 2 )
      create(:merchant, id: 3)

      get "/api/v1/merchants/random"
      random_merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(random_merchant).to have_key("id")
    end
    it "finds a merchant of a given name" do 
      merchant1 = create(:merchant, name: "Nico")
      merchant2 = create(:merchant, name: "Lewis")

      get "/api/v1/merchants/find?name=Lewis"
      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["name"]).to eq("Lewis")
    end

    it "finds all merchants with a given name" do 
      merchant1 = create(:merchant, name: "Nico")
      merchant2 = create(:merchant, name: "Nico")

      get "/api/v1/merchants/find_all?name=Nico"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant).to be_an(Array)
      expect(merchant.count).to be(2)
    end

    it "finds a merchant from a given id" do 
      merchant1 = create(:merchant, name: "Nico", id: 1)
      merchant2 = create(:merchant, name: "Lewis", id: 2 )

      get "/api/v1/merchants/find?id=1"
      merchant = JSON.parse(response.body)
    
      expect(response).to be_successful
      expect(merchant["name"]).to eq("Nico")
    end

    it "finds all merchants from a given id" do 
      merchant1 = create(:merchant, name: "Nico", id: 1)
      merchant2 = create(:merchant, name: "Lewis", id: 2 )

       get "/api/v1/merchants/find_all?id=1"

       merchant = JSON.parse(response.body)

       expect(response).to be_successful
       expect(merchant).to be_an(Array)
       expect(merchant.first['name']).to eq("Nico")
    end

    it "finds a merchant from a given created at" do 
      merchant1 = create(:merchant, name: "Nico", created_at: "2018-01-23T20:23:21.571Z")
     
      get "/api/v1/merchants/find?created_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant['name']).to eq("Nico")
    end

    it "finds all merchants from a given created at" do 
      merchant1 = create(:merchant, created_at: "2018-01-23T20:23:21.571Z")
      merchant2 = create(:merchant, created_at: "2018-01-23T20:23:21.571Z")

      get "/api/v1/merchants/find_all?created_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant).to be_an(Array)
      expect(merchant.count).to eq(2)
    end

    it "finds a given merchant from an updated at" do 
       merchant1 = create(:merchant, name: "Nico", updated_at: "2018-01-23T20:23:21.571Z")
     
      get "/api/v1/merchants/find?updated_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant['name']).to eq("Nico")
    end

    it "finds all merchants from a given updated at" do 
      merchant1 = create(:merchant, updated_at: "2018-01-23T20:23:21.571Z")
      merchant2 = create(:merchant, updated_at: "2018-01-23T20:23:21.571Z")

      get "/api/v1/merchants/find_all?updated_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant).to be_an(Array)
      expect(merchant.count).to eq(2)

    end

    it "returns the revenue for a given merchant" do
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)

      create(:invoice_item, invoice: invoice, item: item1, unit_price: 111, quantity: 1)
      create(:invoice_item, invoice: invoice, item: item2, unit_price: 222, quantity: 3)

      create(:transaction, result: "success", invoice: invoice)

      get "/api/v1/merchants/#{merchant.id}/revenue"

      revenue = JSON.parse(response.body)
      expect(response).to be_successful
      expect(revenue['revenue']).to eq("7.77")
    end
    it "returns the revenue for a merchant given a date" do 
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)

      create(:invoice_item, invoice: invoice, item: item1, unit_price: 111, quantity: 1, created_at: "2012-03-27 14:54:11")
      create(:invoice_item, invoice: invoice, item: item2, unit_price: 222, quantity: 3, created_at: "2012-03-27 14:54:11")
      create(:invoice_item, invoice: invoice, item: item2, unit_price: 222, quantity: 3, created_at: "2012-03-29 14:54:11")

      create(:transaction, result: "success", invoice: invoice)

      get "/api/v1/merchants/#{merchant.id}/revenue?date=2012-03-27 14:54:11"

      revenue = JSON.parse(response.body)
      expect(response).to be_successful
      expect(revenue['revenue']).to eq("7.77")
    end
    it " returns the customer who has conducted the most total number of successful transactions" do 
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      customer1 = create(:customer)
      invoice1 = create(:invoice, merchant: merchant, customer: customer1)
      transaction1 = create(:transaction, result: "success", invoice: invoice1)
      transaction2 = create(:transaction, result: "success", invoice: invoice1)
      create(:invoice_item, invoice: invoice1, item: item, unit_price: 111, quantity: 1, created_at: "2012-03-27 14:54:11")


      customer2 = create(:customer)
      invoice2 = create(:invoice, merchant: merchant, customer: customer2)
      transaction3 = create(:transaction, result: "success", invoice: invoice2)
      create(:invoice_item, invoice: invoice2, item: item, unit_price: 111, quantity: 1, created_at: "2012-03-27 14:54:11")


      get "/api/v1/merchants/#{merchant.id}/favorite_customer"

      favorite_customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(favorite_customer["id"]).to eq(customer1.id)
    end
    it "returns the top x merchants ranked by total number of items sold" do 
      merchant1 = create(:merchant)
      invoice1 = create(:invoice, merchant: merchant1)
      transaction1 = create(:transaction, result: "success", invoice: invoice1)
      create(:invoice_item, invoice: invoice1, unit_price: 111, quantity: 2, created_at: "2012-03-27 14:54:11")
      create(:invoice_item, invoice: invoice1, unit_price: 111, quantity: 1, created_at: "2012-03-27 14:54:11")

      merchant2 = create(:merchant)
      invoice2 = create(:invoice, merchant: merchant2)
      transaction2 = create(:transaction, result: "success", invoice: invoice2)
      create(:invoice_item, invoice: invoice2, unit_price: 111, quantity: 2, created_at: "2012-03-27 14:54:11")

      merchant3 = create(:merchant)
      create(:invoice_item, unit_price: 111, quantity: 1, created_at: "2012-03-27 14:54:11")

      get "/api/v1/merchants/most_items?quantity=2"

      merchant_response = JSON.parse(response.body)
      first_merchant = merchant_response.first
      second_merchant = merchant_response.second
    
      expect(response).to be_successful
      expect(merchant_response.class).to eq(Array)
      expect(merchant_response.count).to eq(2)
      expect(first_merchant["id"]).to eq(merchant1.id)
      expect(second_merchant["id"]).to eq(merchant2.id)
    end

    it "returns a merchant where the customer has conducted the most successful transactions" do 
      customer1 = create(:customer, id: 1)

      merchant1 = create(:merchant)
      invoice1 = create(:invoice, merchant: merchant1, customer: customer1)
      transaction1 = create(:transaction, result: "success", invoice: invoice1)
      transaction2 = create(:transaction, result: "success", invoice: invoice1)


      merchant2 = create(:merchant)

      get  "/api/v1/customers/1/favorite_merchant"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["id"]).to eq(merchant1.id) 
    end
    it "returns the top x merchants ranked by total revenue" do 
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)

      invoice1 = create(:invoice, merchant: merchant1)
      invoice2 = create(:invoice, merchant: merchant2)
      invoice3 = create(:invoice, merchant: merchant3)
      
      transaction = create(:transaction, invoice: invoice1, result: "success") 
      transaction = create(:transaction, invoice: invoice2, result: "success") 
      transaction = create(:transaction, invoice: invoice3, result: "success") 

      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 3, unit_price: 3)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 1)
      invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 2)
      invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 1, unit_price: 1)

      
      get "/api/v1/merchants/most_revenue?quantity=2"
      
      top_merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(top_merchants.count).to eq(2)
      expect(top_merchants.first["id"]).to eq(merchant1.id)
    end
    # it "returns the total revenue for date x across all merchants" do 
      
    #   get "/api/v1/merchants/revenue?date="
    #   GET /api/v1/merchants/revenue?date=x
    # end
  end 
end