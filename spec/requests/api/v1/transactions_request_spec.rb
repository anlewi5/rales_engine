require "rails_helper"

describe "transaction requests" do
  it "returns data for all transactions" do 
    create_list(:transaction, 3)

    get "/api/v1/transactions"
    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(3)
    expect(transactions.first).to have_key("result")
  end
  it "returns a transaction given the id" do 
    create(:transaction, id: 1)
    create(:transaction)
    create(:transaction)

    get "/api/v1/transactions/1"

    transaction = JSON.parse(response.body)
    
    expect(response).to be_successful
    expect(transaction["id"]).to eq(1)
  end
  it "can find a transactions given the id" do 
    create(:transaction, id: 1)
    create(:transaction)
    create(:transaction)

     get "/api/v1/transactions/find?id=1"

    transaction = JSON.parse(response.body)
    expect(transaction["id"]).to eq(1)
  end
   it "can find all transactions given the id" do 
    create(:transaction, id: 1)
    create(:transaction)
    create(:transaction)

     get "/api/v1/transactions/find_all?id=1"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction.first["id"]).to eq(1)
  end

  it "can find a transaction given an invoice id" do 
    invoice_id = create(:transaction).invoice_id

    get api_v1_transactions_find_path(invoice_id: invoice_id)
    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["invoice_id"]).to eq(invoice_id)

  end

  it "can find all the transactions given an invoice id " do 
    invoice_id = create(:transaction).invoice_id
    create(:transaction, invoice_id: invoice_id)

    get api_v1_transactions_find_all_path(invoice_id: invoice_id)
    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(2)
  end

  it "can find a transaction given a created at" do 
    create(:transaction, credit_card_number: "12345", created_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/transactions/find?created_at=2018-01-23T20:23:21.571Z"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction['credit_card_number']).to eq("12345")
  end

  it "can find all transactions given a created at" do 
    create(:transaction, credit_card_number: "12345", created_at: "2018-01-23T20:23:21.571Z")
    create(:transaction, credit_card_number: "54321",created_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/transactions/find_all?created_at=2018-01-23T20:23:21.571Z"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction.first['credit_card_number']).to eq("12345")
    expect(transaction.second['credit_card_number']).to eq("54321")
  end

  it "can find a transaction given a updated at" do 
    create(:transaction, credit_card_number: "12345", updated_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/transactions/find?updated_at=2018-01-23T20:23:21.571Z"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction['credit_card_number']).to eq("12345")
  end

  it "can find all transactions given an updated at" do 
    create(:transaction, credit_card_number: "12345", updated_at: "2018-01-23T20:23:21.571Z")
    create(:transaction, credit_card_number: "54321",updated_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/transactions/find_all?updated_at=2018-01-23T20:23:21.571Z"

    transactions = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transactions.first['credit_card_number']).to eq("12345")
    expect(transactions.second['credit_card_number']).to eq("54321")
  end 
  it "can find a transaction given a credit card number" do
    transaction1 = create(:transaction)
    create(:transaction)

    get "/api/v1/transactions/find?credit_card_number=#{transaction1.credit_card_number}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction['credit_card_number']).to eq(transaction1.credit_card_number)
  end
   it "can find all transactions given a credit card number" do
    transaction1 = create(:transaction, credit_card_number: "12345")
    transaction2 = create(:transaction, credit_card_number: "12345")

    get "/api/v1/transactions/find_all?credit_card_number=12345"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.first['credit_card_number']).to eq("12345")
    expect(transactions.second['credit_card_number']).to eq("12345")
  end
  it "can find a transaction given a result" do 
    create(:transaction, result: "success")

     get "/api/v1/transactions/find?result=success"
     transaction = JSON.parse(response.body)

     expect(response).to be_successful
     expect(transaction["result"]).to eq("success")
  end
   it "can find all transactions given a result" do 
    create(:transaction, result: "success")
    create(:transaction, result: "success")

    get "/api/v1/transactions/find_all?result=success"
    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.first["result"]).to eq("success")
    expect(transactions.second["result"]).to eq("success")
  end
end