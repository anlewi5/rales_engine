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
      merchant1 = create(:merchant, created_at: "2018-01-23T20:23:21.571Z")
     
      get "/api/v1/merchants/find?created_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant['created_at']).to eq("2018-01-23T20:23:21.571Z")
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
       merchant1 = create(:merchant, updated_at: "2018-01-23T20:23:21.571Z")
     
      get "/api/v1/merchants/find?updated_at=2018-01-23T20:23:21.571Z"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant['updated_at']).to eq("2018-01-23T20:23:21.571Z")
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

  end 
end