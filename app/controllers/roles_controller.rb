class RolesController < ApplicationController
  def switch
    if current_user.has_role? params[:role], :any
      session[:current_role] = params[:role]
      redirect_to root_path, notice: "You are now acting as a #{params[:role].humanize}"
    else
      redirect_to root_path, warning: "You are not a #{params[:role].humanize}"
    end
  end
end
