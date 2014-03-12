class BuildingEnergyProfilesController < ApplicationController

  before_filter :load_building

  def index
    @building_profiles = get_profiles
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

  def edit
    @bui
  end

  private

  def profile_types
     BuildingEnergyProfile::ELECTRICITY_TYPES + BuildingEnergyProfile::FOSSIL_FUEL_TYPES
  end

  def get_profiles
    profile_types.map do |type|
      get_profile_by_type(type)
    end
  end

  def get_profile_by_type(profile_type)
      @building.
        energy_profiles.
        find_or_initialize_by_profile_type(profile_type)
  end

  def load_building
    @building = Building.find(params[:building_id])
  end

  private

  def energy_profile_params
    params.
      require(:building_energy_profile).
      permit!
  end

end
