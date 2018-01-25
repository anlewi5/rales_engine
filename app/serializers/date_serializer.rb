class DateSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :invoice_id, :created_at, :updated_at
end