class RemoveRateToCountryTaxCode < ActiveRecord::Migration[6.0]
  def change
    remove_column :country_tax_codes, :rate
  end
end
