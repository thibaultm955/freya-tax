class AddIsHiddenToEntityTaxCode < ActiveRecord::Migration[6.0]
  def change
    add_column :entity_tax_codes, :is_hidden, :boolean
  end
end
