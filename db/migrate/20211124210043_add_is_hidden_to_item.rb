class AddIsHiddenToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :is_hidden, :boolean
  end
end
