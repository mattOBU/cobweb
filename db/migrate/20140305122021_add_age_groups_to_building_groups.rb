class AddAgeGroupsToBuildingGroups < ActiveRecord::Migration
  def change
    add_column :building_groups, :age_groups, :boolean
  end
end
