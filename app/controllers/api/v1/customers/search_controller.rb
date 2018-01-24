class Api::V1::Customers::SearchController < ApplicationController
  def show 
    render json: Customer.search(params)
  end

  def index
    render json: Customer.search_all(params)
  end
end