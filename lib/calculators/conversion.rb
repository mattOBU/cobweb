class Conversion
  KWH_IN_TJ = 277777.778

  def self.TJ_to_kWh(tj)
    tj*KWH_IN_TJ
  end

  # factors from excel sheet
  def self.kgCO2_from_kWh(fuel, kwh)
    emission_factor(fuel)*kwh
  end

# kCO2 per TJ from Excel sheet
#-- fossil
# Diesel oil                              74,1106
# Natural gas                             56,1051
# Liquified Petroleum Gases               63,1051
# Gasoline                                74,1106
# Anthracite coal                         98,3115
#-- biomass
# Wood or Wood waste (pellets?)           112,304
# in current wireframes: gas, oil, lpg, anthracite, pellets
# converting to kgCO2e / kWh
  def self.emission_factor(fuel)
    case fuel
    when :electricity
      0.569737
    when :gas
      56.1051/KWH_IN_TJ
    when :oil
      74.1106/KWH_IN_TJ
    when :lpg
      63.1051/KWH_IN_TJ
    when :anthracite
      98.3115/KWH_IN_TJ
    when :pellets
      112.304/KWH_IN_TJ
    end 
  end
end
