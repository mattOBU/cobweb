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

  def yearly_data
    case granularity
    when "monthly"
      [ m01_value , m02_value , m03_value , m04_value , m05_value , m06_value ,
      m07_value , m08_value , m09_value , m10_value , m11_value , m12_value].map {|v| zero_default(v) }.reduce(:+)
    when "quarterly"
      [q1_value, q2_value, q3_value, q4_value].map {|v| zero_default(v) }.reduce(:+)
    else
      yearly_value
    end
  end

  def quarterly_data
    case granularity
    when "monthly"
      {q1: [m01_value, m02_value, m03_value].map {|v| zero_default(v) }.reduce(:+),
       q2: [m04_value, m05_value, m06_value].map {|v| zero_default(v) }.reduce(:+),
       q3: [m07_value, m08_value, m09_value].map {|v| zero_default(v) }.reduce(:+),
       q4: [m10_value, m11_value, m12_value].map {|v| zero_default(v) }.reduce(:+) }
    when "quarterly"
      {q1: q1_value, q2: q2_value, q3: q3_value, q4: q4_value}
    end
  end

  def monthly_data
    {Jan: m01_value, Feb: m02_value, Mar: m03_value, Apr: m04_value, May: m05_value, Jun: m06_value,
     Jul: m07_value, Aug: m08_value, Sep: m09_value, Oct: m10_value, Nov: m11_value, Dec: m12_value}
  end

  def zero_default(number)
    number || 0
  end
end
