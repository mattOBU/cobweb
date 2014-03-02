class Manage::CommunityGroupsController < ApplicationController
  def index
    @community_groups = CommunityGroup.all
  end
end
