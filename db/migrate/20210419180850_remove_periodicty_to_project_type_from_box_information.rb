class RemovePeriodictyToProjectTypeFromBoxInformation < ActiveRecord::Migration[6.0]
  def change
    remove_column :box_informations, :periodicity_to_project_type_id
  end
end
