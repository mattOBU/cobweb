class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :community_group
end
