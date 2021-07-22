class RemoveCountryToCustomer < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :country
    add_reference :customers, :country, null: false, foreign_key: true

  end
end
