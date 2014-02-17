class Project < ActiveRecord::Base
  geocoded_by :location
  after_validation :geocode, if: -> (obj) {
    obj.location.present? && obj.location_changed? }

  resourcify

  has_many :properties
  has_many :memberships
  has_many :members, source: :user, through: :memberships
end
