class BuildingsController < ApplicationController

  def new
    @building = Building.new
    render action: :edit
  end

  def create
    @building = Building.new(building_params)
    authorize! :write, @building
    @building.user = current_user
    if @building.save
      redirect_to root_path, info: "The building has been saved"
    else
      flash[:error] = "There was an error saving the new building"
      render action: :edit
    end
  end

  def edit
    @building = Building.find(params[:id])
    authorize! :write, @building
  end

  def update
    @building = Building.find(params[:id])
    authorize! :write, @building
    if @building.update_attributes(building_params)
      redirect_to root_path, info: "The building has been saved"
    else
      flash[:error] = "There was an error saving the building"
      render action: :edit
    end

  end

  def show
    @building = Building.find(params[:id])
  end

  def search
    @postcode= params[:term]
    @buildings = Building.near(params[:term], 20, units: :km)
    render :json => @buildings.map {|b| b.search_json }
  end

  private

  def building_params
    params.
      require(:building).
      permit(:name, :street_number, :street_name, :city,
             :postcode, :year_of_construction, :number_of_occupants,
             :floor_area, :category)
  end
end
