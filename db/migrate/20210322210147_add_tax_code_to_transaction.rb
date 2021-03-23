class AddTaxCodeToTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :tax_code
    add_reference :transactions, :entity_tax_code, null: false, foreign_key: true
  end
end
