class Api::V1::Merchants::ReportsController < ApplicationController 
  def revenue
    render json: Merchant.revenue(id: params[:id])
  end
end