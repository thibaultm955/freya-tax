class CreateBoxTaxCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :box_tax_codes do |t|
      t.references :countries, null: false, foreign_key: true
      t.references :box_informations, null: false, foreign_key: true
      t.references :tax_code_operation_sides, null: false, foreign_key: true
      t.references :tax_code_operation_locations, null: false, foreign_key: true
      t.references :tax_code_operation_types, null: false, foreign_key: true
      t.references :tax_code_operation_rates, null: false, foreign_key: true

      t.timestamps
    end
  end
end
