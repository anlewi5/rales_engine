class Api::V1::Merchants::ReportsController < ApplicationController 
  def revenue
    render json: Merchant.revenue(params)
  end
end