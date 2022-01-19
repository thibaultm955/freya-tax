class AddRateIdToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :tax_code_operation_rate, foreign_key: true
  end
end
