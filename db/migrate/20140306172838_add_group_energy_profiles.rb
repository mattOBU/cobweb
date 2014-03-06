class AddGroupEnergyProfiles < ActiveRecord::Migration
  def change
    create_table :group_energy_profiles do |t|
      t.string :age_group
      t.references :building_group
      ["imported_electricity_consumption", "generated_electricity_consumption", "exported_electricity", "fossil_1_consumption", "fossil_2_consumption"].each do |energy_detail|
        t.string energy_detail
        t.string "#{energy_detail}_unit"
        t.string "#{energy_detail}_accuracy"
      end

      t.timestamps
    end
  end
end
