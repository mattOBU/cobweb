class Calculators::BuildingGroupCalculator
  # use group_energy_profiles over periods

  # to generate:
  # - for all times or per year
  # - just show consumption export if required
  def initialize(building_groups, options)
    @building_groups = building_groups
    @building_groups = [@building_groups] if !@building_groups.is_a?(Array)
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
energy_profile.inspect
    total_energy = Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.generated_electricity_consumption.to_i || 0, energy_profile.generated_electricity_consumption_unit) -
                   Calculators::Conversion.to_kWh(energy_profile.exported_electricity.to_i || 0, energy_profile.exported_electricity_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit) +
                   Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit)
    # placeholder TODO natural gas
    total_emission = Calculators::Conversion.kgCO2_from_kWh("imported electricity consumption", 
                           Calculators::Conversion.to_kWh(energy_profile.imported_electricity_consumption.to_i || 0, energy_profile.imported_electricity_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh("natural gas",
                           Calculators::Conversion.to_kWh(energy_profile.fossil_1_consumption.to_i || 0, energy_profile.fossil_1_consumption_unit)) +
                     Calculators::Conversion.kgCO2_from_kWh("natural gas",
                           Calculators::Conversion.to_kWh(energy_profile.fossil_2_consumption.to_i || 0, energy_profile.fossil_2_consumption_unit))

puts "*"*59
puts total_energy
puts total_emission
puts bg.total_area
puts bg.total_occupancy
puts "*"*59
    data = calculate(total_energy, total_emission, bg.total_area, bg.total_occupancy)
    data.merge({name: bg.name + " " + bg.category, year: bg.year})
  end

  def calculate(total_kWh, total_kgCO2e, area, occupants)
    kWh_m2 = (total_kWh/area).round(2)
    kWh_occ = (total_kWh/occupants).round(2)
    kgCO2e_m2 = (total_kgCO2e/area).round(2)
    kgCO2e_occ = (total_kgCO2e/occupants).round(2)
    {kWh_m2: kWh_m2, kWh_occ: kWh_occ, kgCO2e_m2: kgCO2e_m2, kgCO2e_occ: kgCO2e_occ}
  end
end
