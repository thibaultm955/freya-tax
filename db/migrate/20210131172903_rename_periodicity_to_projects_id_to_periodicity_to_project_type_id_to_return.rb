class RenamePeriodicityToProjectsIdToPeriodicityToProjectTypeIdToReturn < ActiveRecord::Migration[6.0]
  def change
    rename_column :returns, :periodicity_to_project_types_id, :periodicity_to_project_type_id
  end
end
