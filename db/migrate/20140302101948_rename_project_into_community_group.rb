class RenameProjectIntoCommunityGroup < ActiveRecord::Migration
  def change
    rename_table :projects, :community_groups
  end
end
