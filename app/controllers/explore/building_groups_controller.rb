class Explore::BuildingGroupsController < ApplicationController
    def index
    end

    def create
      render json: {query: params.inspect, table: []} and return if params[:building_groups].nil?
      @building_groups = BuildingGroup.find(*params[:building_groups])
      calc = Calculators::BuildingGroupCalculator.new(@building_groups, {metrics: params[:metrics], fossil_fuels: params["fossil_fuels"], consumption_export: params[:electricity_consumption_export]})
      render json: {query: params.inspect, table: calc.table_data}
    end
end
