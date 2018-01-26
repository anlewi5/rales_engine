class Api::V1::Merchants::RevenueController < ApplicationController 
  def index 
    render json: Merchant.revenue(params)
  end
end