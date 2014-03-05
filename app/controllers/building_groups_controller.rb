class BuildingGroupsController < ApplicationController

  def new
    @building_group = BuildingGroup.new
    render action: :edit
  end

  def create
    @building_group = BuildingGroup.new(building_group_params)
    authorize! :write, @building_group
    if @building_group.save
      redirect_to root_path, info: "The building group has been created"
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
      redirect_to root_path, info: "The building group has been saved"
    else
      flash[:error] = "There was an error saving the building group"
      render action: :edit
    end
  end

  private

  def building_group_params
    params.
      require(:building_group).
      permit(:name, :postcode, :city, :year, :category)
  end

end
