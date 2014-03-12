class Building < ActiveRecord::Base

  scope :missing_energy_profile, -> { joins("LEFT OUTER JOIN building_energy_profiles ON buildings.id = building_energy_profiles.building_id").where("building_energy_profiles.id IS NULL") }

  geocoded_by :postcode
  after_validation :geocode, if: -> (obj) {
    obj.postcode.present? && obj.postcode_changed? }

  belongs_to :user
  has_many :energy_profiles, class_name: "BuildingEnergyProfile"

  def address
    "#{name}, #{street_number} #{street_name}, #{postcode} #{city}"
  end

  def search_json
    {id: self.id,
     address: self.address} 
  end
end
