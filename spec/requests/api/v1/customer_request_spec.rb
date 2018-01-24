require 'rails_helper'

describe "customer requests" do 
  it "returns data for all customers" do 
    create_list(:customer,3)

    get "/api/v1/customers"
    customers = JSON.parse(response.body)

    expect(response).to be_successful 
    expect(customers.first).to have_key("first_name")
  end
  it "can find a single  customer by id" do 
    create(:customer, id: 1)

    get "/api/v1/customers/1"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(1)
  end
  it "can find a customer from a given id" do 
    create(:customer, id: 2)

    get "/api/v1/customers/find?id=2"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(2)
  end

  it "can find all the customers with a given id" do 
     create(:customer, id: 2)
     create(:customer, id: 3)

      get "/api/v1/customers/find_all?id=2"

      customer = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customer.first["id"]).to eq(2)
  end

  it "can find a customer given a first name" do 
    create(:customer, first_name: "Nico")

    get "/api/v1/customers/find?first_name=Nico"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["first_name"]).to eq("Nico")
  end

  it "can find all customers given a first name" do 
    create(:customer, first_name: "Nico")
    create(:customer, first_name: "Nico")

    get "/api/v1/customers/find_all?first_name=Nico"

    customers = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customers.count).to eq(2)
  end

  it "can find a customer by their last name" do 
    create(:customer, last_name: "Lewis")

    get "/api/v1/customers/find?last_name=Lewis"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["last_name"]).to eq("Lewis")
  end
  it "can find all customers from a given last name" do 
    create(:customer, last_name: "Lewis")
    create(:customer, last_name: "Lewis")

    get "/api/v1/customers/find_all?last_name=Lewis"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer.count).to eq(2)
  end
  it "can find a customer given a created at date" do 
    create(:customer, created_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/customers/find?created_at=2018-01-23T20:23:21.571Z"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer['created_at']).to eq("2018-01-23T20:23:21.571Z")
  end
  it "can find all customers given a created at date" do 
    create(:customer, created_at: "2018-01-23T20:23:21.571Z")
    create(:customer, created_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/customers/find_all?created_at=2018-01-23T20:23:21.571Z"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer.first['created_at']).to eq("2018-01-23T20:23:21.571Z")
    expect(customer.second['created_at']).to eq("2018-01-23T20:23:21.571Z")
  end
    it "can find a customer given a updated at date" do 
    create(:customer, updated_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/customers/find?updated_at=2018-01-23T20:23:21.571Z"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer['updated_at']).to eq("2018-01-23T20:23:21.571Z")
  end
  it "can find all customers given a updated at date" do 
    create(:customer, updated_at: "2018-01-23T20:23:21.571Z")
    create(:customer, updated_at: "2018-01-23T20:23:21.571Z")

    get "/api/v1/customers/find_all?updated_at=2018-01-23T20:23:21.571Z"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer.first['updated_at']).to eq("2018-01-23T20:23:21.571Z")
    expect(customer.second['updated_at']).to eq("2018-01-23T20:23:21.571Z")
  end

  it "can find a random customer" do 
    create(:customer, id: 1)
    create(:customer, id: 2)
    create(:customer, id: 3)

    get "/api/v1/customers/random"
    random_customer = JSON.parse(response.body)
   
    expect(response).to be_successful
    expect(random_customer).to have_key("id")
  end
  
end