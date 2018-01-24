class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(params)
    case
      when params["id"]
        Merchant.find_by(id: params["id"].to_i)
      when params["name"]
        Merchant.find_by(name: params["name"])
      when params["created_at"]
        Merchant.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Merchant.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Merchant.find_by(id: rand(1..Merchant.count))
    end
  end

  def self.search_all(params)
    case 
      when params["id"]
        Merchant.where(id: params["id"].to_i)
      when params["created_at"]
        Merchant.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Merchant.where(updated_at: params["updated_at"].to_datetime)
      when params["name"]
        Merchant.where(name: params["name"])
    end
  end

  def self.revenue(params)
    revenue = Merchant.joins(invoices: [:transactions, :invoice_items]).
      where(transactions: { result: "success" }).
      where(id: params[:id]).
      group("merchants.id").
      sum("invoice_items.unit_price * invoice_items.quantity").
      values.
      first

    { revenue: revenue / 100.0 }
  end

end
