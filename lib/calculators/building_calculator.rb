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
      if b.energy_profiles.size > 0
        table << energy_row(b)
      end
      table
    end
  end

  # table data: aggregated to yearly figure and adding all energy sources together per building
  def energy_row(building)
    energy_profiles = building.energy_profiles
    table_data = {name: building.name}
    total_energy = energy_profiles.reduce(0) do |energy, profile|
      energy += (profile.yearly_data || 0)
    end
    total_emission = energy_profiles.reduce(0) do |emission, profile|
      emission += Calculators::Conversion.kgCO2_from_kWh(profile.profile_type, profile.yearly_data || 0)
    end
    table_data.merge({year: energy_profiles.first.year})
              .merge(calculate(total_energy, total_emission, building.floor_area, building.number_of_occupants))
  end

  # either:
  # granularity is yearly, and energy profile = monthly or quarterly -> aggregate
  # granularity is quarterly, and energy profile = monthly -> aggregate
  # granularity is monthly
  # there's more than one building: compare at the largest granularity
  def graph_data
    granularity = largest_granularity(@buildings)
    graph = @buildings.reduce([]) do |graphr, b|
      graphr.concat(graph_rows(b, granularity))
    end 
    {metrics: @options[:metrics], time_unit: time_unit(granularity)}.merge({data: graph})
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

  def largest_granularity(buildings)
    granularities = buildings.map { |b| b.energy_profiles.map { |p| p.granularity }}.uniq
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
puts "HERE!!!"
    energy_profiles = building.energy_profiles
puts energy_profiles.size
    energy_profiles.reduce([]) do |rows, energy_profile|
      rows.concat(energy_profile_rows(building, energy_profile, granularity))
puts "HERE"
      puts energy_profile_rows(building, energy_profile, granularity)
      rows
    end
  end

  def energy_profile_rows(building, energy_profile, granularity)
    case granularity
    when "monthly"
      consumption = energy_profile.monthly_data
      calculated_data = consumption.reduce([]) do |memo, (key, value)|
        emission = Calculators::Conversion.kgCO2_from_kWh(energy_profile.profile_type, value)
        calculated_values = calculate(value, emission, building.floor_area, building.number_of_occupants)
        memo.concat(graph_row(calculated_values, building, {:month => key}))
      end
    when "quarterly"
      consumption = energy_profile.quarterly_data
      calculated_data = consumption.reduce([]) do |memo, (key, value)|
        emission = Calculators::Conversion.kgCO2_from_kWh(energy_profile.profile_type, value)
        calculated_values = calculate(value, emission, building.floor_area, building.number_of_occupants)
        memo.concat(graph_row(calculated_values, building, {:quarter => key}))
      end
    when "yearly"
      consumption = energy_profile.yearly_data
      emission = Calculators::Conversion.kgCO2_from_kWh(energy_profile.profile_type, consumption)
      calculated_data = calculate(consumption, emission, building.floor_area, building.number_of_occupants)
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

  # for table: sum all the values of the kwh, sum all the converted values for co2, and then divide those by m2 and occ
  # for graphs we need the individual numbers


  def calculate(total_kWh, total_kgCO2e, area, occupants)
    kWh_m2 = (total_kWh/area).round(2)
    kWh_occ = (total_kWh/occupants).round(2)
    kgCO2e_m2 = (total_kgCO2e/area).round(2)
    kgCO2e_occ = (total_kgCO2e/occupants).round(2)
    {kWh_m2: kWh_m2, kWh_occ: kWh_occ, kgCO2e_m2: kgCO2e_m2, kgCO2e_occ: kgCO2e_occ}
  end

end
