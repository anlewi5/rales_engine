class Api::V1::Merchants::ReportsController < ApplicationController 
  def revenue
    render json: Merchant.revenue(params)
  end
  def favorite_customer
    render json: Merchant.favorite_customer(params[:id])
  end

  def most_items 
    render json: Merchant.most_items(params)
  end
end