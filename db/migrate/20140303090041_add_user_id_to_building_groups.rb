class AddUserIdToBuildingGroups < ActiveRecord::Migration
  def change
    add_reference :building_groups, :user
  end
end
