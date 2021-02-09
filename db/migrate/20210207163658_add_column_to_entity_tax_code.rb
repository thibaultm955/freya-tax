class AddColumnToEntityTaxCode < ActiveRecord::Migration[6.0]
  def change
    add_reference :entity_tax_codes, :country_tax_codes, null: false, foreign_key: true
    add_column :entity_tax_codes, :is_reverse_charge, :boolean
    add_column :entity_tax_codes, :is_benefit_in_kind, :boolean
    add_column :entity_tax_codes, :is_exempt_supply_article_44, :boolean
  end
end
