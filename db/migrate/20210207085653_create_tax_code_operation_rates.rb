class CreateTaxCodeOperationRates < ActiveRecord::Migration[6.0]
  def change
    create_table :tax_code_operation_rates do |t|
      t.string :name

      t.timestamps
    end
  end
end
