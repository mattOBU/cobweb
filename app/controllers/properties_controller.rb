class BuildingsController < ApplicationController
  def new
    @building = Building.new
    render action: :edit
  end

  def edit
    @building = Building.find(params[:id])
    authorize! :write, @building
  end
  def show
    @building = Building.find(params[:id])
  end
end
