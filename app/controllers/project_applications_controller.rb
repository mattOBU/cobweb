class ProjectApplicationsController < ApplicationController
  def new
    @project = Project.new
  end

  def create
    project = Project.find(params[:project_id])
    app = ProjectApplication.new(user: current_user, project: project)

    if app.save
      redirect_to project, notice: "Thank you for applying!"
    else
      redirect_to project, alert: "Something went wrong"
    end
  end
end
