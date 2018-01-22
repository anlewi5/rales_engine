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
  end 
end