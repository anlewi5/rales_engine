require 'rails_helper'

describe "items API" do
  context "get request" do 
    it "returns a list of all items" do 
      items = create_list(:item, 3)
    
      get '/api/v1/items'

      items = JSON.parse(response.body)

      expect(response).to be_successful 
      expect(items.count).to eq(3)
    end

    it "returns a single item by id" do
      item = create(:item)

      get "/api/v1/items/#{item.id}"

      item_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_response['name']).to eq(item.name)
      expect(item_response['description']).to eq(item.description)
      expect(item_response['unit_price']).to eq(item.unit_price)
    end
  end 
end