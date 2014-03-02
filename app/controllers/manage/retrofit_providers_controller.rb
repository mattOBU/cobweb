class Manage::RetrofitProvidersController < ApplicationController
  def index
    @retrofit_providers = User.with_role(:retrofit_provider)
  end
end
