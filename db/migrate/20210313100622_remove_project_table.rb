class RemoveProjectTable < ActiveRecord::Migration[6.0]
  def change
    drop_table  :projects
  end
end
