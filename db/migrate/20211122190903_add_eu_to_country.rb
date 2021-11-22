class AddEuToCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :is_eu, :integer
  end
end
