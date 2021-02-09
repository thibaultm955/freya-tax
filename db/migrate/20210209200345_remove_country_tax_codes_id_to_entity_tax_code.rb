class RemoveCountryTaxCodesIdToEntityTaxCode < ActiveRecord::Migration[6.0]
  def change
    remove_column :entity_tax_codes, :country_tax_codes_id
  end
end
