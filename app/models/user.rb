class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # TODO revisit the association between users and buildings
  has_many :buildings

  def community_groups
    CommunityGroup.with_roles([:member, :group_admin], self)
  end

  def name_or_email
    name || email
  end

  def member_of?(community_group)
    has_role? :member, community_group
  end

  def administrator_of?(community_group)
    has_role? :community_group_administrator, community_group
  end

  def role_for(resource)
    roles.
      where(resource_type: resource.class.name, resource_id: resource.id).
      pluck(:name).
      first
  end
end
