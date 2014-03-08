class AddLatLonToBuildingGroups < ActiveRecord::Migration
  def change
    add_column :building_groups, :latitude, :float
    add_column :building_groups, :longitude, :float
  end
end
