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

  def create
    @project = Project.new(project_params)
    if @project.save
      @project.members << current_user
      current_user.add_role :owner, @project
      redirect_to @project, notice: "Your new project was successfully created"
    else
      redirect_to :index
    end
  end

  private

  def project_params
    params.require(:project).permit(:location, :name, :description)
  end
end
