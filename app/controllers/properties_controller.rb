class PropertiesController < ApplicationController
  def new
    @property = Property.new
    render action: :edit
  end

  def edit
    @property = Property.find(params[:id])
    authorize! :write, @property
  end
  def show
    @property = Property.find(params[:id])
  end
end
