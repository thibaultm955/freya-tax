class UpdateQuantityToFloatInItemTransaction < ActiveRecord::Migration[6.0]
  def change
    change_column :item_transactions, :quantity, :float
  end
end
