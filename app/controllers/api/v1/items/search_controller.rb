class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: Item.search(params)
  end
end