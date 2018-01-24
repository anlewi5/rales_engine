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


  def self.businessintelligence(params)
    if params["date"]
      revenue_by_date(params)
    else
      revenue(params)
    end
  end

  def self.revenue(params)
    revenue = Merchant.joins(invoices: [:transactions, :invoice_items]).
      merge(Transaction.successful).
      where(id: params[:id]).
      group("merchants.id").
      sum("invoice_items.unit_price * invoice_items.quantity").
      values.
      first
    
    { revenue: revenue / 100.0 }
  end

  def self.revenue_by_date(params)
    revenue = Merchant.select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:transactions, :invoice_items])
    .where(id: params[:id])
    .merge(Transaction.successful)
    .where(invoice_items: { created_at: params["date"] } )
    .group(:id)
    .first
    .revenue

    { revenue: revenue / 100.0 }
  end

end
