class RemoveProjects < ActiveRecord::Migration[6.0]
  def down
    drop_table  :projects
  end
end
