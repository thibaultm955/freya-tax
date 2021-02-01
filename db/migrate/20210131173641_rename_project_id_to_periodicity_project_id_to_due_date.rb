class RenameProjectIdToPeriodicityProjectIdToDueDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :due_dates, :project_id, :periodicity_to_project_type_id
  end
end
