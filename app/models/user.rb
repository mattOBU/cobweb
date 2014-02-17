class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :projects, through: :memberships
  has_many :properties, through: :projects

  def level
    "admin"
  end

  def name_or_email
    name || email
  end
end
