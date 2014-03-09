class EnergyProfilesController < ApplicationController

  before_filter :load_building

  def show
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

  def get_energy_profile
    if @building.building_energy_profile
      @building.building_energy_profile
    else
      @building.build_building_energy_profile
    end
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
