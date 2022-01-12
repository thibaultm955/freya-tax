class AddFieldsToBox < ActiveRecord::Migration[6.0]
  def change
    add_reference :boxes, :periodicities, foreign_key: true
    add_reference :boxes, :project_types,  foreign_key: true
    remove_column :boxes, :periodicity_to_project_type_id
  end
end
