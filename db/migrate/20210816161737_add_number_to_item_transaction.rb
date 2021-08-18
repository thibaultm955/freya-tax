class AddNumberToItemTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :item_transactions, :net_amount, :float
    add_column :item_transactions, :vat_amount, :float
  end
end
