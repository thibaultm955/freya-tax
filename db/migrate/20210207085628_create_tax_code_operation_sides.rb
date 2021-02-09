class CreateTaxCodeOperationSides < ActiveRecord::Migration[6.0]
  def change
    create_table :tax_code_operation_sides do |t|
      t.string :name

      t.timestamps
    end
  end
end
