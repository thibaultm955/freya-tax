class AddLanguageCountryToCountry < ActiveRecord::Migration[6.0]
  def change
    add_reference :countries, :language_country, foreign_key: true
    remove_column :countries, :language_id

  end
end
