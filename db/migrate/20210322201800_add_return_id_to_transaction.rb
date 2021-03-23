class AddReturnIdToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :return, null: false, foreign_key: true
  end
end
