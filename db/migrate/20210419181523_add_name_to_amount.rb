class AddNameToAmount < ActiveRecord::Migration[6.0]
  def change
    add_column :amounts, :name, :string
  end
end
