class AddBuildingGroups < ActiveRecord::Migration
  def change
    create_table :building_groups do |t|
      t.string :name
      t.string :postcode
      t.string :city
      t.string :year
      t.string :category
      t.string :granularity # whole, city, postcode
      t.timestamps
    end
  end
end
