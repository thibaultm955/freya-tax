class RenamePeriodictyToProjectTypeToPeriodicityToProjectType < ActiveRecord::Migration[6.0]
  def change
    rename_table :periodicty_to_project_types, :periodicity_to_project_type
  end
end
