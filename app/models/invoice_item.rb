class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  def self.search(params)
    case
      when params["id"]
        find(params["id"])
      when params["quantity"]
        find_by(quantity: params["quantity"])
      when params["unit_price"]
        find_by(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["item_id"]
        find_by(item_id: params["item_id"])
      when params["invoice_id"]
        find_by(invoice_id: params["invoice_id"])
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
      when params["quantity"]
        where(quantity: params["quantity"])
      when params["unit_price"]
        where(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["item_id"]
        where(item_id: params["item_id"])
      when params["invoice_id"]
        where(invoice_id: params["invoice_id"])
      when params["created_at"]
        where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
