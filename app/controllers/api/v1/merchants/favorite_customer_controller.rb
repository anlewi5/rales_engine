class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def index 
    render json: Merchant.favorite_customer(params[:id])
  end
end