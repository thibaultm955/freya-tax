class RemoveItemTransaction < ActiveRecord::Migration[6.0]
  def change
    drop_table  :item_transactions

  end
end
