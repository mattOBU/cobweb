class AddBuildingEnergyProfile < ActiveRecord::Migration
  def change
    create_table :building_energy_profiles do |t|
      t.string :granularity

      t.integer :year
      t.string  :consumption_type
      t.string  :consumption_accuracy

      t.string :fossil_fuel_type
      t.string :fossil_fuel_accuracy

      t.float :yearly_consumption
      t.float :yearly_fossil_fuel

      t.float :q1_consumption
      t.float :q2_consumption
      t.float :q3_consumption
      t.float :q4_consumption
      t.float :q1_fossil_fuel
      t.float :q2_fossil_fuel
      t.float :q3_fossil_fuel
      t.float :q4_fossil_fuel

      t.float :m01_consumption
      t.float :m02_consumption
      t.float :m03_consumption
      t.float :m04_consumption
      t.float :m05_consumption
      t.float :m06_consumption
      t.float :m07_consumption
      t.float :m08_consumption
      t.float :m09_consumption
      t.float :m10_consumption
      t.float :m11_consumption
      t.float :m12_consumption
      t.float :m01_fossil_fuel
      t.float :m02_fossil_fuel
      t.float :m03_fossil_fuel
      t.float :m04_fossil_fuel
      t.float :m05_fossil_fuel
      t.float :m06_fossil_fuel
      t.float :m07_fossil_fuel
      t.float :m08_fossil_fuel
      t.float :m09_fossil_fuel
      t.float :m10_fossil_fuel
      t.float :m11_fossil_fuel
      t.float :m12_fossil_fuel

      t.references :building
      t.timestamps
    end
  end
end
