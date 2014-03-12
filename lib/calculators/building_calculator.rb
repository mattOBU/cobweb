# intent: calculate kWh/m2 and occupant, and kgCO2e/m2 and occupant
# for single building:
# return with available granularity
# for multiple buildings:
# return with largest available granularity
class Calculators::BuildingCalculator
  def initialize(buildings, options)
    @buildings = buildings
    @buildings = [@buildings] if !@buildings.kind_of?(Array)
    @options = options
  end

  def table_data
    @buildings.reduce([]) do |table, b|
      table << energy_row(b)
    end
  end

  # table data: aggregated to yearly figure
  def energy_row(building)
    energy_profile = building.building_energy_profile
    table_data = {name: building.name}
    consumption, fossil_fuel = energy_profile.yearly_data
    energy_numbers = calculate(consumption, fossil_fuel, energy_profile.fossil_fuel_type, building.floor_area, building.number_of_occupants)
    table_data = table_data.merge({year: energy_profile.year}).merge(energy_numbers)
    table_data
  end

  # either:
  # granularity is yearly, and energy profile = monthly or quarterly -> aggregate
  # granularity is quarterly, and energy profile = monthly -> aggregate
  # granularity is monthly
  # there's more than one building: compare at the largest granularity
  def graph_data
    granularity = largest_granularity(@buildings.map {|b| b.building_energy_profile.present? ? b.building_energy_profile.granularity : "monthly" })
    graph = @buildings.reduce([]) do |graph_rows, b|
      graph_rows.concat(graph_rows(b, granularity))
    end 
    {metrics: @options[:metrics], fossil_fuels: @options[:fossil_fuels], time_unit: time_unit(granularity)}.merge({data: graph})
  end

  def time_unit(granularity)
    case granularity
    when "monthly"
      "month"
    when "quarterly"
      "quarter"
    when  "yearly"
      "year"
    end
  end

  def largest_granularity(gr)
    granularities = gr.uniq
    if granularities.include?("yearly")
      return "yearly"
    elsif granularities.include?("quarterly")
      return "quarterly"
    else
      return "monthly"
    end
  end

  # depending on options: metrics, fossil fuels
  # desired result:
  # if kWh_m2 is unit
  # [{month: xxx, building-name: z, kWh_m2: o}] 
  # or
  # [{quarter: yyy, building-name:...
  def graph_rows(building, granularity)
    energy_profile = building.building_energy_profile
    return [] if energy_profile.nil?
    case granularity
    when "monthly"
      consumption, fossil_fuel = energy_profile.monthly_data
      calculated_data = consumption.reduce([]) do |memo, (key, value)|
        calculated_values = calculate(value, fossil_fuel[key], energy_profile.fossil_fuel_type, building.floor_area, building.number_of_occupants)
        memo.concat(graph_row(calculated_values, building, {:month => key}))
      end
    when "quarterly"
      consumption, fossil_fuel = energy_profile.quarterly_data
      calculated_data = consumption.reduce([]) do |memo, (key, value)|
        calculated_values = calculate(value, fossil_fuel[key], energy_profile.fossil_fuel_type, building.floor_area, building.number_of_occupants)
        memo.concat(graph_row(calculated_values, building, {:quarter => key}))
      end
    when "yearly"
      consumption, fossil_fuel = energy_profile.yearly_data
      calculated_data = calculate(consumption, fossil_fuel, energy_profile.fossil_fuel_type, building.floor_area, building.number_of_occupants)
      graph_row(calculated_data, building, {:year => energy_profile.year})
    end
  end

  def graph_row(calculated_values, building, time)
    calculated_values.reduce([]) do |result, (key, value)|
      if @options[:metrics].include?(key.to_s)
        result << {:energy => value, :metric => key.to_s, :"building-name" => building.name}.merge(time)
      end
      result
    end
  end

  def calculate(electricity_kwh, fossil_fuel_kwh, fossil_fuel_type, area, occupants)
    total_kWh = electricity_kwh + fossil_fuel_kwh
    kWh_m2 = (total_kWh/area).round(2)
    kWh_occ = (total_kWh/occupants).round(2)

    total_kgCO2e = Calculators::Conversion.kgCO2_from_kWh("electricity", electricity_kwh) + Calculators::Conversion.kgCO2_from_kWh(fossil_fuel_type, fossil_fuel_kwh)
    kgCO2e_m2 = (total_kgCO2e/area).round(2)
    kgCO2e_occ = (total_kgCO2e/occupants).round(2)

    {kWh_m2: kWh_m2, kWh_occ: kWh_occ, kgCO2e_m2: kgCO2e_m2, kgCO2e_occ: kgCO2e_occ}
  end
end
