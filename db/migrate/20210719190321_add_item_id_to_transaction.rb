class AddItemIdToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :item, foreign_key: true
  end
end
