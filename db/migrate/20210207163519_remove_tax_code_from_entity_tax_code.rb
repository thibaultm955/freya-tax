class RemoveTaxCodeFromEntityTaxCode < ActiveRecord::Migration[6.0]
  def change
    remove_column :entity_tax_codes, :tax_code
  end
end
