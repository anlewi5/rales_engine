class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  default_scope { order(:id) }

  def self.search(params)
    case
      when params["id"]
        find(params["id"])
      when params["name"]
        find_by(name: params["name"])
      when params["description"]
        find_by(description: params["description"])
      when params["unit_price"]
        find_by(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["merchant_id"]
        find_by(merchant_id: params["merchant_id"])
      when params["created_at"]
        find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        find_by(updated_at: params["updated_at"].to_datetime)
      when params
        find(rand(1..Item.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        where(id: params["id"])
      when params["name"]
        where(name: params["name"])
      when params["description"]
        where(description: params["description"])
      when params["unit_price"]
        where(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["merchant_id"]
        where(merchant_id: params["merchant_id"])
      when params["created_at"]
        where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        where(updated_at: params["updated_at"].to_datetime)
    end
  end
end


