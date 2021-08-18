class AddPriceAndEntityToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :price, :float
    add_reference :items, :entity, null: false, foreign_key: true
  end
end
