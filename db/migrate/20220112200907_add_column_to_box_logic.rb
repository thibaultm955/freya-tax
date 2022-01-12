class AddColumnToBoxLogic < ActiveRecord::Migration[6.0]
  def change
    add_reference :box_logics, :box, foreign_key: true
    add_reference :box_logics, :operation_type, foreign_key: true
    add_reference :box_logics, :document_type, foreign_key: true
    remove_column :box_logics, :box_name_id
  end
end
