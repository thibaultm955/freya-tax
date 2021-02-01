class RenamePeriodicityToProjectTypeToPeriodicityToProjectTypes < ActiveRecord::Migration[6.0]
  def change
    rename_table :periodicity_to_project_type, :periodicity_to_project_types
  end
end
