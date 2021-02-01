class RemovePeriodicityToProjectTypeToDueDate < ActiveRecord::Migration[6.0]
  def change
    remove_column :due_dates, :periodicity_to_project_type_id
  end
end
