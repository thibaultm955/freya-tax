class CreateReturnBoxes < ActiveRecord::Migration[6.0]
  def change
    create_table :return_boxes do |t|
      t.float :amount
      t.references :box_informations, null: false, foreign_key: true
      t.references :returns, null: false, foreign_key: true

      t.timestamps
    end
  end
end
