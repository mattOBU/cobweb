class MakeBuildingEnergyProfilesMoreGeneric < ActiveRecord::Migration
  def change
    drop_table :building_energy_profiles
    create_table :building_energy_profiles do |t|
      t.string :granularity

      t.integer :year
      t.string  :profile_type
      t.string  :profile_accuracy

      t.float   :yearly_value
      t.float   :q1_value
      t.float   :q2_value
      t.float   :q3_value
      t.float   :q4_value
      t.float   :m01_value
      t.float   :m02_value
      t.float   :m03_value
      t.float   :m04_value
      t.float   :m05_value
      t.float   :m06_value
      t.float   :m07_value
      t.float   :m08_value
      t.float   :m09_value
      t.float   :m10_value
      t.float   :m11_value
      t.float   :m12_value
      t.references :building
      t.timestamps
    end
  end
end
