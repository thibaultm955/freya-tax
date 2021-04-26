class UpdateReturnsIdToReturnBox < ActiveRecord::Migration[6.0]
  def change
    remove_column :return_boxes, :returns_id
    add_reference :return_boxes, :return, null: false, foreign_key: true
  end
end
