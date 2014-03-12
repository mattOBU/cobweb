class BuildingGroupsController < ApplicationController

  def new
    @building_group = BuildingGroup.new
    (BuildingGroup::AGE_GROUPS << "all").each do |age_group|
      @building_group.group_energy_profiles.build(age_group: age_group)
    end
    render action: :edit
  end

  def create
    @building_group = BuildingGroup.new(building_group_params)
    authorize! :write, @building_group
    @building_group.user = current_user
    if @building_group.save
      redirect_to root_path, notice: "The building group has been created"
    else
      flash[:error] = "There was a problem creating the building group"
      render action: :edit
    end
  end

  def edit
    @building_group = BuildingGroup.find(params[:id])
    authorize! :write, @building_group
  end

  def update
    @building_group = BuildingGroup.find(params[:id])
    authorize! :write, @building_group
    if @building_group.update_attributes(building_group_params)
      redirect_to root_path, notice: "The building group has been saved"
    else
      flash[:error] = "There was an error saving the building group"
      render action: :edit
    end
  end

  # TODO search on location
  def search
    @building_groups = BuildingGroup.near(params[:term], 20, units: :km)
    render :json => @building_groups.map {|bg| bg.search_json }
  end

  private

  def building_group_params
    params.
      require(:building_group).
      permit(:name, :postcode, :city, :year, :category, :age_groups,
             :total_area, :total_occupancy, :area_accuracy, :occupancy_accuracy,
             group_energy_profiles_attributes: [
               :age_group,
               :imported_electricity_consumption,
               :imported_electricity_consumption_unit,
               :imported_electricity_consumption_accuracy,

               :generated_electricity_consumption,
               :generated_electricity_consumption_unit,
               :generated_electricity_consumption_accuracy,

               :exported_electricity,
               :exported_electricity_unit,
               :exported_electricity_accuracy,

               :fossil_1_consumption,
               :fossil_1_consumption_unit,
               :fossil_1_consumption_accuracy,

               :fossil_2_consumption,
               :fossil_2_consumption_unit,
               :fossil_2_consumption_accuracy,

             ]  )
  end

end
