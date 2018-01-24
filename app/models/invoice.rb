class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

    def self.search(params)
    case
      when params["id"]
        find(params["id"])
      when params["status"]
        find_by(status: params["status"])
      when params["customer_id"]
        find_by(customer_id: params["customer_id"])
      when params["merchant_id"]
        find_by(merchant_id: params["merchant_id"])
      when params["created_at"]
        find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        find_by(updated_at: params["updated_at"].to_datetime)
      when params
        find(rand(1..Invoice.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        where(id: params["id"])
      when params["status"]
        where(status: params["status"])
      when params["customer_id"]
        where(customer_id: params["customer_id"])
      when params["merchant_id"]
        where(merchant_id: params["merchant_id"])
      when params["created_at"]
        where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
