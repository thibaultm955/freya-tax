class AddCountryToBoxName < ActiveRecord::Migration[6.0]
  def change
    add_reference :box_names, :country, null: false, foreign_key: true
  end
end
