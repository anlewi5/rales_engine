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
  end 
end