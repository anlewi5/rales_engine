require 'rails_helper'

describe "invoice_items API" do
  context "get request" do 
    it "returns a list of all invoice_items" do 
      invoice_items = create_list(:invoice_item, 3)
    
      get '/api/v1/invoice_items'

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful 
      expect(invoice_items.count).to eq(3)
    end

    it "returns a single invoice_item by id" do
      invoice_item = create(:invoice_item, unit_price: 101)
 
      get "/api/v1/invoice_items/#{invoice_item.id}"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item_response['quantity']).to eq(invoice_item.quantity)
      expect(invoice_item_response['unit_price']).to eq("1.01")
      expect(invoice_item_response['item_id']).to eq(invoice_item.item_id)
      expect(invoice_item_response['invoice_id']).to eq(invoice_item.invoice_id)
    end

    it "finds a random invoice_item" do
      create(:invoice_item, id: 1)
      create(:invoice_item, id: 2)
      create(:invoice_item, id: 3)

      get "/api/v1/invoice_items/random"

      invoice_item_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item_response).to have_key("id")
      expect(invoice_item_response).to have_key("quantity")
      expect(invoice_item_response).to have_key("unit_price")
      expect(invoice_item_response).to have_key("item_id")
      expect(invoice_item_response).to have_key("invoice_id")
      expect(invoice_item_response).not_to have_key("updated_at")
      expect(invoice_item_response).not_to have_key("created_at")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/invoice_items/find?#{params}" }

        let(:invoice_item_response) { JSON.parse(response.body) }

        before(:each) do
          item = create(:item, id: 1)
          invoice = create(:invoice, id: 1)
          create(:invoice_item, id: 1,
                           quantity: 1,
                           unit_price: 101,
                           item_id: item.id,
                           invoice_id: invoice.id,
                           created_at: "2012-03-06T16:54:31",
                           updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single invoice_item" do
          it "finds the correct invoice_item" do
            subject
            expect(response).to be_success
            expect(invoice_item_response["id"]).to eq(1)
            expect(invoice_item_response["quantity"]).to eq(1)
            expect(invoice_item_response["unit_price"]).to eq("1.01")
            expect(invoice_item_response["item_id"]).to eq(1)
            expect(invoice_item_response["invoice_id"]).to eq(1)
          end
        end

        context "by id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by quantity" do
          let(:params) { "quantity=1" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by unit_price" do
          let(:params) { "unit_price=1.01" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by item_id" do
          let(:params) { "item_id=1" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by invoice_id" do
          let(:params) { "invoice_id=1" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single invoice_item"
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single invoice_item"
        end
      end

      describe "find_all?" do
        subject { get "/api/v1/invoice_items/find_all?#{params}" }

        let(:invoice_item_response) { JSON.parse(response.body) }

        before(:each) do
          same_item = create(:item, id: 1)
          different_item = create(:item, id: 2)
          same_invoice = create(:invoice, id: 1)
          different_invoice = create(:invoice, id: 2)

          create(:invoice_item, id: 1,
                           quantity: 1,
                           unit_price: 101,
                           item_id: same_item.id,
                           invoice_id: same_invoice.id,
                           created_at: "2012-03-06T16:54:31",
                           updated_at: "2013-03-06T16:54:31"
          )
          create(:invoice_item, id: 2,
                           quantity: 1,
                           unit_price: 101,
                           item_id: same_item.id,
                           invoice_id: same_invoice.id,
                           created_at: "2012-03-06T16:54:31",
                           updated_at: "2013-03-06T16:54:31"
          )
          create(:invoice_item, id: 3,
                           quantity: 2,
                           unit_price: 201,
                           item_id: different_item.id,
                           invoice_id: different_invoice.id,
                           created_at: "2012-04-06T16:54:31",
                           updated_at: "2013-04-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds invoice_item(s)" do |*invoice_item_ids|
          it "finds the correct invoice_item(s)" do
            subject
            expect(response).to be_success
            expect(invoice_item_response).to be_an Array
            expect(invoice_item_response.map { |result| result['id'] }).to contain_exactly(*invoice_item_ids)
          end
        end

        context "by id" do
          let(:params) { "id=2" }
          it_behaves_like 'a response that finds invoice_item(s)', 2
        end

        context "by quantity" do
          let(:params) { "quantity=1" }
          it_behaves_like 'a response that finds invoice_item(s)', 1, 2
        end

        context "by unit_price" do
          let(:params) { "unit_price=1.01" }
          it_behaves_like "a response that finds invoice_item(s)", 1, 2
        end

        context "by item_id" do
          let(:params) { "item_id=1" }
          it_behaves_like "a response that finds invoice_item(s)", 1, 2
        end

        context "by invoice_id" do
          let(:params) { "invoice_id=1" }
          it_behaves_like "a response that finds invoice_item(s)", 1, 2
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds invoice_item(s)", 1, 2
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds invoice_item(s)", 1, 2
        end
      end
    end
  end 
end