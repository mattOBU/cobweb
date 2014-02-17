class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :projects, through: :memberships
  has_many :properties, through: :projects

  def name_or_email
    name || email
  end

  def member_of?(project)
    projects.include? project
  end

  def role_for(resource)
    roles.
      where(resource_type: resource.class.name, resource_id: resource.id).
      pluck(:name).
      first
  end
end
