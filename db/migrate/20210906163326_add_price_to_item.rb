class AddPriceToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :net_amount, :float
    add_column :items, :vat_amount, :float
    remove_column :items, :price

  end
end
