class AddProjectApplication < ActiveRecord::Migration
  def change
    create_table :project_applications do |t|
      t.references :project
      t.references :user
      t.string :status

      t.timestamps
    end
  end
end
