class Api::V1::Merchants::PendingController < ApplicationController

  def index
    render json: Merchant.pending_customers(params[:id])
  end

end