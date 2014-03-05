class RemoveGranularityFromBuildingGroups < ActiveRecord::Migration
  def change
    remove_column :building_groups, :granularity
  end
end
