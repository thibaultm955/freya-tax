class AddRateToTaxCodeOperationRate < ActiveRecord::Migration[6.0]
  def change
    add_column :tax_code_operation_rates, :rate, :float
  end
end
