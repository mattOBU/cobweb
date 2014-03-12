class Calculators::BuildingGroupCalculator

  def initialize(building_groups, buildings, options)
    @building_groups = building_groups
    @building_groups = [@building_groups] if !@building_groups.is_a?(Array)
    @buildings = buildings
    @buildings = [@buildings] if !@buildings.is_a?(Array)
    @options = options
  end

  # desired: yearly metrics naming category and group
  def table_data
    @building_groups.reduce([]) do |table, bg|
      table << energy_row(bg)
    end
  end

  # either we have one row for a year or we have broken down over age groups
  # we select the one that has no age group (so for now)
  def energy_row(bg)
    energy_profile = bg.group_energy_profiles.where(age_group: "all").first
    total_energy = Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.generated_electricity_consumption.to_i || 0, energy_profile.generated_electricity_consumption_unit) -
                   Calculators::Conversion.to_kWh(energy_profile.exported_electricity.to_i || 0, energy_profile.exported_electricity_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit)
    total_emission = Calculators::Conversion.kgCO2_from_kWh("imported electricity consumption", 
                           Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh(energy_profile.fossil_1_consumption_type,
                           Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh(energy_profile.fossil_2_consumption_type,
                           Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit))

    data = calculate(total_energy, total_emission, bg.total_area, bg.total_occupancy)
    data.merge({name: bg.name + " " + bg.category, year: bg.year})
  end

  # compare individidual buildings against the group calculated average
  # several metrics allowed
  # can filter on type of energy
  def graph_data
    graph = @building_groups.reduce([]) do |data, bg|
      data.concat(graph_bg_row(bg))
    end
    building_rows = @buildings.reduce([]) do |memo, building|
      building_results = building.energy_profiles.reduce({}) do |building_data, energy_profile|
        consumption = energy_profile.yearly_data
        emission = Calculators::Conversion.kgCO2_from_kWh(energy_profile.profile_type, consumption)
        building_data[:consumption] ||= 0
        building_data[:consumption] += consumption
        building_data[:emission] ||= 0
        building_data[:emission] += emission
        building_data
      end
      calculated_data = calculate(building_results[:consumption], building_results[:emission], building.floor_area, building.number_of_occupants) 
      rows_for_metrics = graph_row(calculated_data, building, {:year => building.energy_profiles.last.year}) # vile hack for year TODO
      memo.concat(rows_for_metrics)
    end
    {metrics: @options[:metrics], time_unit: "yearly", data: graph.concat(building_rows)}
  end

  def graph_bg_row(bg)
    energy_profile = bg.group_energy_profiles.where(age_group: "all").first
    total_energy = Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.generated_electricity_consumption.to_i || 0, energy_profile.generated_electricity_consumption_unit) -
                   Calculators::Conversion.to_kWh(energy_profile.exported_electricity.to_i || 0, energy_profile.exported_electricity_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit)
    total_emission = Calculators::Conversion.kgCO2_from_kWh("imported electricity consumption", 
                           Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh(energy_profile.fossil_1_consumption_type,
                           Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh(energy_profile.fossil_2_consumption_type,
                           Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit))

    group_data = calculate(total_energy, total_emission, bg.total_area, bg.total_occupancy)
    graph_row(group_data, bg, {:year => bg.year})
  end

  def graph_row(calculated_values, building, time)
    calculated_values.reduce([]) do |result, (key, value)|
      if @options[:metrics].include?(key.to_s)
        result << {:energy => value, :metric => key.to_s, :"building-name" => building.name}.merge(time)
      end
      result
    end
  end

  def calculate(total_kWh, total_kgCO2e, area, occupants)
    kWh_m2 = (total_kWh/area).round(2)
    kWh_occ = (total_kWh/occupants).round(2)
    kgCO2e_m2 = (total_kgCO2e/area).round(2)
    kgCO2e_occ = (total_kgCO2e/occupants).round(2)
    {kWh_m2: kWh_m2, kWh_occ: kWh_occ, kgCO2e_m2: kgCO2e_m2, kgCO2e_occ: kgCO2e_occ}
  end
end
