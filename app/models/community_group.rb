class CommunityGroup < ActiveRecord::Base
  geocoded_by :location

  after_validation :geocode, if: -> (obj) {
    obj.location.present? && obj.location_changed? }

  resourcify

  # the association with the users is managed via rolify
  # hence the method below to get hold of the buildings
  def buildings
    Building.where(
      user_id: users.map(&:id)
    )
  end

  def members
    User.with_role(:member, self)
  end

  def admins
    User.with_role(:community_group_administrator, self)
  end

  def users
    (members + admins).uniq
  end

  def contact_name
    admins.first.name_or_email unless admins.empty?
  end

  def contact_email
    admins.first.email unless admins.empty?
  end

  def identifier
    "#{self.name}, #{self.location}"
  end

  def search_json
    {id: self.id,
     identifier: self.identifier}
  end

end
