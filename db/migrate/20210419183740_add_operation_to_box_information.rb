class AddOperationToBoxInformation < ActiveRecord::Migration[6.0]
  def change
    add_reference :box_informations, :tax_code_operation_location, null: false, foreign_key: true
    add_reference :box_informations, :tax_code_operation_rate, null: false, foreign_key: true
    add_reference :box_informations, :tax_code_operation_side, null: false, foreign_key: true
    add_reference :box_informations, :tax_code_operation_type, null: false, foreign_key: true
  end
end
