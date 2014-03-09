class BuildingGroup < ActiveRecord::Base
  AGE_GROUPS = %w(Pre-1919 1919-1944 1945-1964 1965-1980 1981-1990 Post-1990)

  geocoded_by :location_for_geocoding
  after_validation :geocode

  has_many :group_energy_profiles
  accepts_nested_attributes_for :group_energy_profiles
  belongs_to :user

  def sector
    case category
    when "all"
      "whole"
    when "single-family", "multi-family"
      "residential"
    else
      "non-residential"
    end
  end

  def location_scope
    postcode.present? ? "Postcode #{postcode}" : "City wide"
  end

  private

  def location_for_geocoding
    return "#{postcode} United Kingdom" if postcode.present?
    return "#{city} United Kingdom" if city.present?
    "United Kingdom"
  end
end
