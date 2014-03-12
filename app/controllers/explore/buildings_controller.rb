class Explore::BuildingsController < ApplicationController
    def index
    end

    def create
      render json: {query: params.inspect, table: []} and return if params[:buildings].nil?
      @buildings = Building.find(*params[:buildings])
      calc = Calculators::BuildingCalculator.new(@buildings, {metrics: params[:metrics], fossil_fuels: params["fossil_fuels"], consumption_export: params[:electricity_consumption_export]})
      render json: {query: params.inspect, table: calc.table_data, graph: calc.graph_data}
    end
end
