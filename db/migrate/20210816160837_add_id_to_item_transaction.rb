class AddIdToItemTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :item_transactions, :item, null: false, foreign_key: true
    add_reference :item_transactions, :transaction, null: false, foreign_key: true
  end
end
