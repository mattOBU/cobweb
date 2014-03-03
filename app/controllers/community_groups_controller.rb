class CommunityGroupsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @community_groups = current_user.community_groups
  end

  def show
    @community_group = CommunityGroup.find(params[:id])
  end

  def search
    @postcode= params[:postcode]
    @community_groups = CommunityGroup.near(params[:postcode], 20, units: :km)
    render :index
  end

  def create
    @community_group = CommunityGroup.new(community_group_params)
    if @community_group.save
      @community_group.members << current_user
      current_user.add_role :group_admin, @community_group
      redirect_to @community_group, notice: "Your new community group was successfully created"
    else
      redirect_to :index
    end
  end

  private

  def community_group_params
    params.
      require(:community_group).
      permit(:location, :name, :description)
  end
end
