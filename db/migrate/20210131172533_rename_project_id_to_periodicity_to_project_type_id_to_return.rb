class RenameProjectIdToPeriodicityToProjectTypeIdToReturn < ActiveRecord::Migration[6.0]
  def change
    rename_column :returns, :project_id, :periodicity_to_project_types_id
  end
end
