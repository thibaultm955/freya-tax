class DropTablePeriodicityToProjectType < ActiveRecord::Migration[6.0]
  def change
    remove_column :due_dates, :periodicity_to_project_type_id
    add_reference :due_dates, :periodicity,  foreign_key: true
    add_reference :due_dates, :project_type,  foreign_key: true
    drop_table :periodicity_to_project_types
  end
end
