class RemoveBoxInformationToReturnBox < ActiveRecord::Migration[6.0]
  def change
    remove_column :return_boxes, :box_informations_id
    add_reference :return_boxes, :box_name, null: false, foreign_key: true
  end
end
