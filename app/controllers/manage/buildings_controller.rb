class Manage::BuildingsController < ApplicationController
  def index
    @buildings = current_user.buildings
    @building_groups = current_user.building_groups
  end
end
