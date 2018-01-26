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
      item = create(:item, unit_price: 101)

      get "/api/v1/items/#{item.id}"

      item_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_response['name']).to eq(item.name)
      expect(item_response['description']).to eq(item.description)
      expect(item_response['unit_price']).to eq("1.01")
      expect(item_response['merchant_id']).to eq(item.merchant_id)
    end

    it "finds a random item" do
      create(:item, id: 1)
      create(:item, id: 2)
      create(:item, id: 3)

      get "/api/v1/items/random"

      item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(item_response).to have_key("id")
      expect(item_response).to have_key("name")
      expect(item_response).to have_key("description")
      expect(item_response).to have_key("unit_price")
      expect(item_response).not_to have_key("updated_at")
      expect(item_response).not_to have_key("created_at")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/items/find?#{params}" }

        let(:item_response) { JSON.parse(response.body) }

        before(:each) do
          merchant = create(:merchant, id: 1)
          create(:item, id: 1,
                        name: "ItemName",
                        description: "ItemDescription",
                        unit_price: 101,
                        merchant_id: merchant.id,
                        created_at: "2012-03-06T16:54:31",
                        updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single item" do
          it "finds the correct item" do
            subject
            expect(response).to be_success
            expect(item_response["id"]).to eq(1)
            expect(item_response["name"]).to eq("ItemName")
            expect(item_response["description"]).to eq("ItemDescription")
            expect(item_response["unit_price"]).to eq("1.01")
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
          let(:params) { "unit_price=1.01" }
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

      describe "find_all?" do
        subject { get "/api/v1/items/find_all?#{params}" }

        let(:item_response) { JSON.parse(response.body) }

        before(:each) do
          same_merchant = create(:merchant, id: 1)
          different_merchant = create(:merchant, id: 2)
          create(:item, id: 1,
                        name: "SameName",
                        description: "SameDescription",
                        unit_price: 101,
                        merchant_id: same_merchant.id,
                        created_at: "2012-03-06T16:54:31",
                        updated_at: "2013-03-06T16:54:31"
          )
          create(:item, id: 2,
                        name: "SameName",
                        description: "SameDescription",
                        unit_price: 101,
                        merchant_id: same_merchant.id,
                        created_at: "2012-03-06T16:54:31",
                        updated_at: "2013-03-06T16:54:31"
          )
          create(:item, id: 3,
                        name: "DifferentName",
                        description: "DifferentDescription",
                        unit_price: 201,
                        merchant_id: different_merchant.id,
                        created_at: "2012-02-06T16:54:31",
                        updated_at: "2013-02-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds item(s)" do |*item_ids|
          it "finds the correct item(s)" do
            subject
            expect(response).to be_success
            expect(item_response).to be_an Array
            expect(item_response.map { |result| result['id'] }).to contain_exactly(*item_ids)
          end
        end

        context "by id" do
          let(:params) { "id=2" }
          it_behaves_like 'a response that finds item(s)', 2
        end

        context "by name" do
          let(:params) { "name=SameName" }
          it_behaves_like 'a response that finds item(s)', 1, 2
        end

        context "by description" do
          let(:params) { "description=SameDescription" }
          it_behaves_like "a response that finds item(s)", 1, 2
        end

        context "by unit_price" do
          let(:params) { "unit_price=1.01" }
          it_behaves_like "a response that finds item(s)", 1, 2
        end

        context "by merchant_id" do
          let(:params) { "merchant_id=1" }
          it_behaves_like "a response that finds item(s)", 1, 2
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds item(s)", 1, 2
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds item(s)", 1, 2
        end
      end
    end
  end 

  describe "business intelligence" do 
    it "returns the date with the most sales for the given item using the invoice date" do 
      item = create(:item, id: 2)
      invoice1 = create(:invoice)
      invoice_item1 = create(:invoice_item, quantity: 2, invoice: invoice1, item: item)
      transaction1 = create(:transaction, result: "success", invoice: invoice1)


      invoice2 = create(:invoice)
      invoice_item2 = create(:invoice_item, quantity: 1, invoice: invoice2, item: item)
      transaction2 = create(:transaction, result: "success", invoice: invoice2)

      get "/api/v1/items/#{item.id}/best_day"

      item_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_response.first["created_at"]).to eq(invoice1.created_at.to_json.to_s.delete! '\"\\')
    end

    it "returns the top x item instances ranked by total number sold" do 
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)

      invoice = create(:invoice)
        
      create(:transaction, invoice: invoice, result: "success") 

      create(:invoice_item, item: item1, invoice: invoice, quantity: 1)
      create(:invoice_item, item: item1, invoice: invoice, quantity: 1)
      create(:invoice_item, item: item2, invoice: invoice, quantity: 2)
      create(:invoice_item, item: item3, invoice: invoice, quantity: 1)
      
      get "/api/v1/items/most_items?quantity=2"
    
      top_items_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(top_items_response).to be_an(Array)
      expect(top_items_response.count).to eq(2)
      expect(top_items_response.first["id"]).to eq(item1.id)
      expect(top_items_response.second["id"]).to eq(item2.id) 
    end

    it "returns the top x items ranked by total revenue generated" do 
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)

      invoice1 = create(:invoice)
      
      create(:transaction, invoice: invoice1, result: "success") 

      create(:invoice_item, item: item1, invoice: invoice1, quantity: 3, unit_price: 3)
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 1, unit_price: 1)
      create(:invoice_item, item: item2, invoice: invoice1, quantity: 2, unit_price: 2)
      create(:invoice_item, item: item3, invoice: invoice1, quantity: 1, unit_price: 1)

      get "/api/v1/items/most_revenue?quantity=2"

      top_items_response = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(top_items_response.count).to eq(2)
      expect(top_items_response.first["id"]).to eq(item1.id)
      expect(top_items_response.second["id"]).to eq(item2.id)
    end
  end
end