class AddMembership < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :project
      t.timestamps
    end
  end
end
