class Api::V1::Customers::ReportsController < ApplicationController
  def favorite_merchant
    render json: Customer.favorite_merchant(params[:id])
  end
end