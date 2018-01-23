require 'rails_helper'

describe "items API" do
  context "get requests" do 
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

    describe "queries" do
      describe "find?"
        subject { get "/api/v1/items/find?#{params}" }

        let(:item_response) { JSON.parse(response.body) }

        before(:each) do
          merchant = create(:merchant, id: 1)
          create(:item, id: 1,
                        name: "ItemName",
                        description: "ItemDescription",
                        unit_price: 100,
                        merchant_id: merchant.id,
                        created_at: "2012-03-06T16:54:31",
                        updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single item" do
          #GET /api/v1/merchants/find?parameters
          it "finds the correct item" do
            subject
            expect(response).to be_success
            expect(item_response["id"]).to eq(1)
            expect(item_response["name"]).to eq("ItemName")
            expect(item_response["description"]).to eq("ItemDescription")
            expect(item_response["unit_price"]).to eq(100)
            expect(item_response["merchant_id"]).to eq(1)
          end
        end

        context "by id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single item"
        end

        context "by name" do
          let(:params) { "name=ItemName" }
          it_behaves_like "a response that finds a single item"
        end

        context "by description" do
          let(:params) { "description=ItemDescription" }
          it_behaves_like "a response that finds a single item"
        end

        context "by unit_price" do
          let(:params) { "unit_price=100" }
          it_behaves_like "a response that finds a single item"
        end

        context "by merchant_id" do
          let(:params) { "merchant_id=1" }
          it_behaves_like "a response that finds a single item"
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single item"
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single item"
        end
      end
    end
  end 