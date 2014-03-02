class Manage::GroupsController < ApplicationController
  def index
    @community_groups = CommunityGroup.all
  end
end
