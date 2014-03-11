class Explore::BuildingsController < ApplicationController
    def index
    end

    def create
      params[:buildings] ||= []
      @buildings = Building.find(*params[:buildings])
      calc = Calculators::BuildingCalculator.new(@buildings)
      render json: {query: params.inspect, table: calc.table_data}
    end
end
