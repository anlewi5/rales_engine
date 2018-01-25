class Customer < ApplicationRecord
  has_many :invoices

  has_many :merchants, through: :invoices

  def self.search(params)
    case 
      when params["id"]
        find(params["id"].to_i)
      when params["first_name"]
        find_by(first_name: params["first_name"]) 
      when params["last_name"]
        find_by(last_name: params["last_name"])
      when params["created_at"]
        find_by(created_at: params["created_at"])
      when params["updated_at"]
        find_by(updated_at: params["updated_at"])
      when params
        find_by(id: rand(1..Customer.count))
    end
  end

  def self.search_all(params) 
    case 
      when params["id"]
        where(id: params["id"].to_i) 
      when params["first_name"]
        where(first_name: params["first_name"])
      when params["last_name"]
        where(last_name: params["last_name"])
      when params["created_at"]
        where(created_at: params["created_at"])
      when params["updated_at"]
        where(updated_at: params["updated_at"])
    end 
  end

  def self.favorite_merchant(customer_id)
     Merchant.joins(:invoices, invoices: :transactions)
     .where(invoices: {customer_id: customer_id} )
     .merge(Transaction.successful)
     .group(:id)
     .order("count(merchants.id) DESC")
     .first
  end


end
