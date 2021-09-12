class RemoveLanguageCountryToCountry < ActiveRecord::Migration[6.0]
  def change
    remove_column :countries, :language_country_id
  end
end
