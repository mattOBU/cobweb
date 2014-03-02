class Building < ActiveRecord::Base
  geocoded_by :postcode
  after_validation :geocode, if: -> (obj) {
    obj.postcode.present? && obj.postcode_changed? }

  belongs_to :user

  # TODO add association with retrofit provider

  def address
    "#{street_number} #{postcode}"
  end

  def co2_m2
    rand(100)
  end

  def co2_occupant
    rand(100)
  end

  def kwh_m2
    rand(100)
  end

  def kwh_occupant
    rand(100)
  end

  def gbp_m2
    rand(100)
  end

  def gbp_occupant
    rand(100)
  end
end
