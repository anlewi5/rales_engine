class Api::V1::Items::BestDayController < ApplicationController 
  def show 
    render json: Item.best_day(params[:id])
  end
end