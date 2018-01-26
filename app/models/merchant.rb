class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  has_many :customers, through: :invoices

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
    if params["date"]
      revenue_by_date(params)
    else
      total_revenue(params)
    end
  end

  def self.favorite_customer(merchant_id)
    Customer.joins(:merchants, invoices: :transactions)
      .where(merchants: {id: merchant_id} )
      .merge(Transaction.successful)
      .group("customers.id")
      .order("count(customers.id) DESC")
      .first
  end

  def self.most_items(params)
    select("merchants.*, sum(invoice_items.quantity) AS total_quantity")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("total_quantity DESC")
    .limit(params[:quantity])
  end
  
  def self.most_revenue(params)
    Merchant.select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue").joins(invoices: [:invoice_items, :transactions]).merge(Transaction.successful).group(:id).order("total_revenue DESC").limit(params[:quantity])
  end

  def self.all_merchant_revenue(params)
    Merchant.where(created_at: "2012-03-27 14:54:00" )
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:transactions, :invoice_items])
    .merge(Transaction.successful)
    .group(:id)
    .order("revenue DESC")
    .sum(:revenue)
  end

  def self.pending_customers(merchant_id)
    find_by_sql(pending_customers_sql(merchant_id))
  end

  def self.pending_customers_sql(merchant_id)
    "SELECT DISTINCT customers.*, transactions.result, merchant.* 
      FROM customers

     INNER JOIN invoices 
      ON invoices.customer_id = customers.id 
     INNER JOIN transactions 
      ON transactions.invoice_id = invoices.id 
     INNER JOIN merchants 
      ON invoices.merchant_id = merchants.id 

     WHERE transactions.result = 'failed' 
      AND merchants.id = #{merchant_id} 
     
     EXCEPT SELECT DISTINCT customers.*, transactions.result, merchant.* 
      FROM customers 

     INNER JOIN invoices 
      ON invoices.customer_id = customers.id 
     INNER JOIN transactions 
      ON transactions.invoice_id = invoices.id 
     INNER JOIN merchants 
      ON invoices.merchant_id = merchants.id

     WHERE transactions.result = 'success' 
      AND merchants.id = #{merchant_id}"
  end
  

  private

  def self.total_revenue(params)
    revenue = revenue_for_merchant(params[:id]).first.revenue
    revenue_to_json(revenue)
  end

  def self.revenue_by_date(params)
    revenue = revenue_for_merchant(params[:id])
      .where(invoice_items: { created_at: params["date"] } )
      .first
      .revenue

    revenue_to_json(revenue)
  end

  def self.revenue_for_merchant(merchant_id)
    Merchant.select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:transactions, :invoice_items])
    .where(id: merchant_id)
    .merge(Transaction.successful)
    .group(:id)
  end

  def self.revenue_to_json(revenue)
    { revenue: (revenue / 100.0).to_s }
  end
end
