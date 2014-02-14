class ProjectsController < ApplicationController

  def index
    @projects = (user_signed_in? ? current_user.projects : Project.all)
  end

  def show
    @project = Project.find(params[:id])
  end

  def search
    @postcode = params[:postcode]
    @projects = Project.near(params[:postcode], 20, units: :km)
    render :index
  end

end
