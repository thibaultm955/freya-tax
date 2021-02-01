class RemoveProjectIdToReturn < ActiveRecord::Migration[6.0]
  def change
    remove_column :returns, :periodicity_id
  end
end
