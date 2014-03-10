class Explore::CommunityGroupsController < ApplicationController
    def index
    end

    def create
      if params[:community_groups].present?
        @community_groups = CommunityGroups.find_with_ids(params[:community_groups])
        render json: []
      else
        render json: []
      end
    end
end
