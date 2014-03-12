class BuildingEnergyProfile < ActiveRecord::Base
  belongs_to :building

  ELECTRICITY_TYPES= [
     "imported electricity consumption",
     "generated electricity consumption",
     "exported electricity"
  ]

  FOSSIL_FUEL_TYPES= [
      "natural gas",
      "oil",
      "LPG",
      "anthracite",
      "wood pellets"
  ]

  def electricity?
    ELECTRICITY_TYPES.include? profile_type
  end

  def fossil_fuel?
    FOSSIL_FUEL_TYPES.include? profile_type
  end

  def monthly_to_yearly
    consumption = m01_consumption +
                    m02_consumption +
                    m03_consumption +
                    m04_consumption +
                    m05_consumption +
                    m06_consumption +
                    m07_consumption +
                    m08_consumption +
                    m09_consumption +
                    m10_consumption +
                    m11_consumption +
                    m12_consumption
    fossil_fuel = m01_fossil_fuel +
                    m02_fossil_fuel +
                    m03_fossil_fuel +
                    m04_fossil_fuel +
                    m05_fossil_fuel +
                    m06_fossil_fuel +
                    m07_fossil_fuel +
                    m08_fossil_fuel +
                    m09_fossil_fuel +
                    m10_fossil_fuel +
                    m11_fossil_fuel +
                    m12_fossil_fuel
    [consumption, fossil_fuel]
  end

  def quarterly_to_yearly
     consumption = q1_consumption + q2_consumption + q3_consumption + q4_consumption
     fossil_fuel = q1_fossil_fuel + q2_fossil_fuel + q3_fossil_fuel + q4_fossil_fuel
     [consumption, fossil_fuel]
  end

  def yearly_data
    case granularity
    when "monthly"
      monthly_to_yearly
    when "quarterly"
      quarterly_to_yearly
    else
      [yearly_consumption, yearly_fossil_fuel]
    end
  end

  def quarterly_data
    case granularity
    when "monthly"
      [{q1: m01_consumption + m02_consumption + m03_consumption,
        q2: m04_consumption + m05_consumption + m06_consumption,
        q3: m07_consumption + m08_consumption + m09_consumption,
        q4: m10_consumption + m11_consumption + m12_consumption},
       {q1: m01_fossil_fuel + m02_fossil_fuel + m03_fossil_fuel,
        q2: m04_fossil_fuel + m05_fossil_fuel + m06_fossil_fuel,
        q3: m07_fossil_fuel + m08_fossil_fuel + m09_fossil_fuel,
        q4: m10_fossil_fuel + m11_fossil_fuel + m12_fossil_fuel}]
    when "quarterly"
      [{q1: q1_consumption, q2: q2_consumption, q3: q3_consumption, q4: q4_consumption},
       {q1: q1_fossil_fuel, q2: q2_fossil_fuel, q3: q3_fossil_fuel, q4: q4_fossil_fuel}]
    end
  end

  def monthly_data
    [{Jan: m01_consumption, Feb: m02_consumption, Mar: m03_consumption, Apr: m04_consumption, May: m05_consumption, Jun: m06_consumption,
      Jul: m07_consumption, Aug: m08_consumption, Sep: m09_consumption, Oct: m10_consumption, Nov: m11_consumption, Dec: m12_consumption},
     {Jan: m01_fossil_fuel, Feb: m02_fossil_fuel, Mar: m03_fossil_fuel, Apr: m04_fossil_fuel, May: m05_fossil_fuel, Jun: m06_fossil_fuel,
      Jul: m07_fossil_fuel, Aug: m08_fossil_fuel, Sep: m09_fossil_fuel, Oct: m10_fossil_fuel, Nov: m11_fossil_fuel, Dec: m12_fossil_fuel}]
  end
end
