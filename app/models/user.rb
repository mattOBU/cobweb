class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # TODO revisit the association between users and buildings
  # homeowner and businesses shouldn't be allowed to "have many"
  # buildings nor any building group
  has_many :buildings
  has_many :building_groups

  def community_groups
    CommunityGroup.with_roles([:member, :community_group_administrator], self)
  end

  def name_or_email
    name || email
  end

  def local_authority?
    has_role? :local_authority
  end

  def landlord?
    has_role? :landlord
  end

  def community_group_administrator?
    has_role? :community_group_administrator, :any
  end

  def homeowner?
    has_role? :homeowner, :any
  end

  def business?
    has_role? :business, :any
  end

  def retrofit_provider?
    has_role? :retrofit_provider
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
