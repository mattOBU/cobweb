# intent: calculate kWh/m2 and occupant, and kgCO2e/m2 and occupant
# for single building:
# return with available granularity
# for multiple buildings:
# return with largest available granularity
class Calculators::BuildingCalculator
  def initialize(buildings)
    @buildings = buildings
    @buildings = [@buildings] if !@buildings.kind_of?(Array)
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
    consumption, fossil_fuel = 0, 0
    case energy_profile.granularity
    when "quarterly"
        consumption = energy_profile.q1_consumption + energy_profile.q2_consumption + energy_profile.q3_consumption + energy_profile.q4_consumption
        fossil_fuel = energy_profile.q1_fossil_fuel + energy_profile.q2_fossil_fuel + energy_profile.q3_fossil_fuel + energy_profile.q4_fossil_fuel
    when "monthly"
        consumption = energy_profile.m01_consumption +
                        energy_profile.m02_consumption +
                        energy_profile.m03_consumption +
                        energy_profile.m04_consumption +
                        energy_profile.m05_consumption +
                        energy_profile.m06_consumption +
                        energy_profile.m07_consumption +
                        energy_profile.m08_consumption +
                        energy_profile.m09_consumption +
                        energy_profile.m10_consumption +
                        energy_profile.m11_consumption +
                        energy_profile.m12_consumption
        fossil_fuel = energy_profile.m01_fossil_fuel +
                        energy_profile.m02_fossil_fuel +
                        energy_profile.m03_fossil_fuel +
                        energy_profile.m04_fossil_fuel +
                        energy_profile.m05_fossil_fuel +
                        energy_profile.m06_fossil_fuel +
                        energy_profile.m07_fossil_fuel +
                        energy_profile.m08_fossil_fuel +
                        energy_profile.m09_fossil_fuel +
                        energy_profile.m10_fossil_fuel +
                        energy_profile.m11_fossil_fuel +
                        energy_profile.m12_fossil_fuel
    else
        consumption = energy_profile.yearly_consumption
        fossil_fuel = energy_profile.yearly_fossil_fuel
    end
    energy_numbers = calculate(consumption, fossil_fuel, energy_profile.fossil_fuel_type, building.floor_area, building.number_of_occupants)
    table_data = table_data.merge({year: energy_profile.year}).merge(energy_numbers)
    table_data
  end

  # either:
  # granularity is yearly, and energy profile = monthly or quarterly -> aggregate
  # granularity is quarterly, and energy profile = monthly -> aggregate
  # granularity is monthly
  def graph_data
    granularity = largest_granularity(@buildings.map {|b| b.building_energy_profile.present? ? b.building_energy_profile.granularity : "monthly" })
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
