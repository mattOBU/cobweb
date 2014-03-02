class ChangePropertyToBuilding < ActiveRecord::Migration
  def change
    rename_table :properties, :buildings
    remove_column :buildings, :project_id
    add_column :buildings, :user_id, :integer
  end
end
