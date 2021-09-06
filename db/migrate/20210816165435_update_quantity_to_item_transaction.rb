class UpdateQuantityToItemTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :item_transactions, :quantity
    add_column :item_transactions, :quantity, :integer

  end
end
