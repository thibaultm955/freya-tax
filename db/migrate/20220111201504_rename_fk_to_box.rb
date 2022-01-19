class RenameFkToBox < ActiveRecord::Migration[6.0]
  def change
    remove_column :boxes, :periodicities_id
    remove_column :boxes, :project_types_id
    remove_column :boxes, :countries_id

    add_reference :boxes, :periodicity, foreign_key: true
    add_reference :boxes, :country, foreign_key: true
    add_reference :boxes, :project_type, foreign_key: true


  end
end
