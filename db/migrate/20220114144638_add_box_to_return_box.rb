class AddBoxToReturnBox < ActiveRecord::Migration[6.0]
  def change
    add_reference :return_boxes, :box, null: false, foreign_key: true
    remove_column :return_boxes, :box_name_id
  end
end
