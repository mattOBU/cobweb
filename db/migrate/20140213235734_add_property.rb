class AddProperty < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :street_number
      t.string :postcode
      t.string :building_type
      t.integer :year_of_construction
      t.integer :number_of_occupants
      t.float   :floor_area

      t.references :project

      t.float   :latitude
      t.float   :longitude

      t.timestamps
    end
  end
end
