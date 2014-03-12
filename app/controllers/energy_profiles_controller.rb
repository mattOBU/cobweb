class EnergyProfilesController < ApplicationController

  before_filter :load_building

  def index
    @building_energy_profile = get_energy_profile

    render :edit
  end

  def create
    @building.create_building_energy_profile(energy_profile_params)

    redirect_to buildings_path
  end

  def edit
    @bui
  end

  private

  # TODO: handle multiple energy profiles
  def get_energy_profile
    if @building.energy_profiles.count > 0
      @building.energy_profiles.first
    else
      @building.energy_profiles.build
    end
  end

  def load_building
    @building = Building.find(params[:building_id])
  end

  private

  def energy_profile_params
    params.
      require(:energy_profile).
      permit!
  end

end
