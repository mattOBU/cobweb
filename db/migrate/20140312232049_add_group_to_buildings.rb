class AddGroupToBuildings < ActiveRecord::Migration
  def change
    remove_column :buildings, :building_group_id
    add_column :buildings, :group_name, :string
  end
end
