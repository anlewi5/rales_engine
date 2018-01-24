class Transaction < ApplicationRecord
  belongs_to :invoice

  def self.search(params)
    case 
      when params["id"]
        find(params["id"].to_i)
      when params["invoice_id"]
        find_by(invoice_id: params["invoice_id"].to_i)
      when params["created_at"]
        find_by(created_at: params["created_at"])
      when params["updated_at"]
        find_by(updated_at: params["updated_at"])
      when params["credit_card_number"]
        find_by(credit_card_number: params["credit_card_number"])
      when params["result"]
        find_by(result: params["result"])
    end
  end



  def self.search_all(params)
    case 
      when params["id"]
        where(id: params["id"].to_i)
      when params["invoice_id"]
        where(invoice_id: params["invoice_id"].to_i)
      when params["created_at"]
        where(created_at: params["created_at"])
      when params["updated_at"]
        where(updated_at: params["updated_at"])
      when params["credit_card_number"]
        where(credit_card_number: params["credit_card_number"])
      when params["result"]
        where(result: params["result"])
    end

  end


end
