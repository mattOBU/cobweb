class Manage::HousingProvidersController < ApplicationController
  def index
    @housing_providers = User.with_role(:landlord)
  end
end
