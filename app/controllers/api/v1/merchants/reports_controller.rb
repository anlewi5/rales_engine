class Api::V1::Merchants::ReportsController < ApplicationController 
  def revenue
    render json: Merchant.businessintelligence(params)
  end
end