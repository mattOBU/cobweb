class BuildingEnergyProfilesController < ApplicationController

  before_filter :load_building

  def index
    load_profiles

    set_profiles_granularity
    set_profiles_year

    render :edit
  end

  def create
    profile = get_profile_by_type(energy_profile_params[:profile_type])

    if (profile.update_attributes(energy_profile_params))
      render :json => profile, status: 200
    else
      render :json => { message: "Failed to save energy profile" }, status: 500
    end
  end

  private

  def profile_types
     BuildingEnergyProfile::ELECTRICITY_TYPES + BuildingEnergyProfile::FOSSIL_FUEL_TYPES
  end

  def load_profiles
    @building_profiles = get_profiles
  end

  def get_profiles
    @profiles ||= profile_types.map do |type|
      get_profile_by_type(type)
    end
  end

  def get_profile_by_type(profile_type)
      @building.
        energy_profiles.
        find_or_initialize_by(profile_type: profile_type)
  end

  def load_building
    @building = Building.find(params[:building_id])
  end

  # naive solution to force a "shared" attribute
  def find_first_with_attribute(collection, attribute)
    collection.
      reject(&:new_record?).
      find { |profile| profile.send(attribute).present? }
  end

  def set_profiles_granularity
    @granularity = find_first_with_attribute(get_profiles, :granularity).
      try(:granularity)
  end

  def set_profiles_year
    @year = find_first_with_attribute(get_profiles, :year).
      try(:year)
  end

  def energy_profile_params
    params.
      require(:building_energy_profile).
      permit!
  end

end
