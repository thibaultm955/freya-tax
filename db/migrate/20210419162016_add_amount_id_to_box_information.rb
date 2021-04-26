class AddAmountIdToBoxInformation < ActiveRecord::Migration[6.0]
  def change
    remove_column :box_informations, :amount
    add_reference :box_informations, :amount, null: false, foreign_key: true
  end
end
