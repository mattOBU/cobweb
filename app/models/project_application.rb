class CommunityGroupApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :community_group

  before_create :set_status

  # TODO manage status

  private

  def set_status
    self.status = 'pending' unless status
  end
end
