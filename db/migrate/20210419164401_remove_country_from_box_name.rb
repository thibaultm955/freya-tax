class RemoveCountryFromBoxName < ActiveRecord::Migration[6.0]
  def change
    remove_column :box_names, :country_id
  end
end
