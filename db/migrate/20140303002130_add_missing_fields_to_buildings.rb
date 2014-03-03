class AddMissingFieldsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :name, :string
    add_column :buildings, :street, :string
    add_column :buildings, :city, :string

    add_column :buildings, :area_accuracy, :string
    add_column :buildings, :occupants_accuract, :string

    add_column :buildings, :category, :string

    add_reference :buildings, :building_group
  end
end
