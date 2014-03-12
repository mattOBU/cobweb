class AddFossilTypesToGroupEnergyProfiles < ActiveRecord::Migration
  def change
    add_column :group_energy_profiles, :fossil_1_consumption_type, :string
    add_column :group_energy_profiles, :fossil_2_consumption_type, :string
  end
end
