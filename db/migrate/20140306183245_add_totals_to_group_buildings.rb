class AddTotalsToGroupBuildings < ActiveRecord::Migration
  def change
    add_column :building_groups, :total_area, :float
    add_column :building_groups, :total_occupancy, :integer

    add_column :building_groups, :area_accuracy, :string
    add_column :building_groups, :occupancy_accuracy, :string
  end
end
