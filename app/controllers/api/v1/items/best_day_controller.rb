class Api::V1::Items::BestDayController < ApplicationController
  def show 
    render json: Item.best_day(params), each_serializer: DateSerializer
  end
end