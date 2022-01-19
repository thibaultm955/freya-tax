class AddPeriodicityAndProjectTypeToReturn < ActiveRecord::Migration[6.0]
  def change
    add_reference :returns, :periodicity,  foreign_key: true
    add_reference :returns, :project_type,  foreign_key: true
    remove_column :returns, :periodicity_to_project_type_id
  end
end
