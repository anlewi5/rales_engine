class Api::V1::Merchants::RevenueDateController < ApplicationController 
  def show 
    render json: Merchant.all_merchant_revenue(params)
  end
end