class CleanTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :total_amount
    add_column :transactions, :quantity, :float
    remove_column :transactions, :entity_tax_code_id
    add_reference :transactions, :item,  foreign_key: true
  end
end
