require 'rails_helper'

describe "Invoices API" do
  context "get request" do 
    it "returns a list of all invoices" do 
      invoices = create_list(:invoice, 3)
    
      get '/api/v1/invoices'

      invoices = JSON.parse(response.body)

      expect(response).to be_successful 
      expect(invoices.count).to eq(3)
    end

    it "returns a single invoice by id" do
      invoice = create(:invoice)

      get "/api/v1/invoices/#{invoice.id}"

      invoice_response = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_response['id']).to eq(invoice.id)
      expect(invoice_response['status']).to eq(invoice.status)
      expect(invoice_response['merchant_id']).to eq(invoice.merchant_id)
      expect(invoice_response['customer_id']).to eq(invoice.customer_id)
    end

    it "finds a random invoice" do
      create(:invoice, id: 1)
      create(:invoice, id: 2)
      create(:invoice, id: 3)

      get "/api/v1/invoices/random"

      invoice_response = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_response).to have_key("id")
      expect(invoice_response).to have_key("status")
      expect(invoice_response).to have_key("merchant_id")
      expect(invoice_response).to have_key("customer_id")
      expect(invoice_response).not_to have_key("updated_at")
      expect(invoice_response).not_to have_key("created_at")
    end

    describe "queries" do
      describe "find?" do
        subject { get "/api/v1/invoices/find?#{params}" }

        let(:invoice_response) { JSON.parse(response.body) }

        before(:each) do
          merchant = create(:merchant, id: 1)
          customer = create(:customer, id: 1)
          create(:invoice, id: 1,
                        status: "InvoiceStatus",
                        merchant_id: merchant.id,
                        customer_id: customer.id,
                        created_at: "2012-03-06T16:54:31",
                        updated_at: "2013-03-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds a single invoice" do
          it "finds the correct invoice" do
            subject
            expect(response).to be_success
            expect(invoice_response["id"]).to eq(1)
            expect(invoice_response["status"]).to eq("InvoiceStatus")
            expect(invoice_response["merchant_id"]).to eq(1)
            expect(invoice_response["customer_id"]).to eq(1)
          end
        end

        context "by id" do
          let(:params) { "id=1" }
          it_behaves_like "a response that finds a single invoice"
        end

        context "by status" do
          let(:params) { "status=InvoiceStatus" }
          it_behaves_like "a response that finds a single invoice"
        end

        context "by merchant_id" do
          let(:params) { "merchant_id=1" }
          it_behaves_like "a response that finds a single invoice"
        end

        context "by merchant_id" do
          let(:params) { "customer_id=1" }
          it_behaves_like "a response that finds a single invoice"
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds a single invoice"
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds a single invoice"
        end
      end

      describe "find_all?" do
        subject { get "/api/v1/invoices/find_all?#{params}" }

        let(:invoice_response) { JSON.parse(response.body) }

        before(:each) do
          same_merchant = create(:merchant, id: 1)
          different_merchant = create(:merchant, id: 2)
          same_customer = create(:customer, id: 1)
          different_customer = create(:customer, id: 2)
          create(:invoice, id: 1,
                           status: "SameStatus",
                           merchant_id: 1,
                           customer_id: 1,
                           created_at: "2012-03-06T16:54:31",
                           updated_at: "2013-03-06T16:54:31"
          )
          create(:invoice, id: 2,
                  status: "SameStatus",
                  merchant_id: 1,
                  customer_id: 1,
                  created_at: "2012-03-06T16:54:31",
                  updated_at: "2013-03-06T16:54:31"
          )
          create(:invoice, id: 3,
                  status: "DifferentStatus",
                  merchant_id: 2,
                  customer_id: 2,
                  created_at: "2012-04-06T16:54:31",
                  updated_at: "2013-04-06T16:54:31"
          )
        end

        shared_examples_for "a response that finds invoice(s)" do |*invoice_ids|
          it "finds the correct invoice(s)" do
            subject
            expect(response).to be_success
            expect(invoice_response).to be_an Array
            expect(invoice_response.map { |result| result['id'] }).to contain_exactly(*invoice_ids)
          end
        end

        context "by id" do
          let(:params) { "id=2" }
          it_behaves_like 'a response that finds invoice(s)', 2
        end

        context "by status" do
          let(:params) { "status=SameStatus" }
          it_behaves_like 'a response that finds invoice(s)', 1, 2
        end

        context "by merchant_id" do
          let(:params) { "merchant_id=1" }
          it_behaves_like "a response that finds invoice(s)", 1, 2
        end

        context "by customer_id" do
          let(:params) { "customer_id=1" }
          it_behaves_like "a response that finds invoice(s)", 1, 2
        end

        context "by created_at" do
          let(:params) { "created_at=2012-03-06T16:54:31" }
          it_behaves_like "a response that finds invoice(s)", 1, 2
        end

        context "by updated_at" do
          let(:params) { "updated_at=2013-03-06T16:54:31" }
          it_behaves_like "a response that finds invoice(s)", 1, 2
        end
      end
    end
  end 
end