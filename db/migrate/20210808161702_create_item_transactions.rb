class CreateItemTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :item_transactions do |t|
      t.float :quantity

      t.timestamps
    end
  end
end
