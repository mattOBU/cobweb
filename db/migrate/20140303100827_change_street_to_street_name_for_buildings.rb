class ChangeStreetToStreetNameForBuildings < ActiveRecord::Migration
  def change
    rename_column :buildings, :street, :street_name
  end
end
