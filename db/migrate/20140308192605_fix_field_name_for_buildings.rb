class FixFieldNameForBuildings < ActiveRecord::Migration
  def change
    rename_column :buildings, :occupants_accuract, :occupants_accuracy
  end
end
