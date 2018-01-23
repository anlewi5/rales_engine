require 'rails_helper'

describe "merchants API" do
  context "get request" do 
    it "returns a list of all merchannts" do 
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
  end 
end