class CommunityGroupApplicationsController < ApplicationController
  def new
    @community_group = CommunityGroup.new
  end

  def create
    community_group = CommunityGroup.find(params[:community_group_id])
    app = CommunityGroupApplication.new(user: current_user, community_group: community_group)

    if app.save
      redirect_to community_group, notice: "Thank you for applying!"
    else
      redirect_to community_group, alert: "Something went wrong"
    end
  end
end
