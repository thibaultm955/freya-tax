class AddEntityTaxCodeToItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :entity_tax_code, foreign_key: true
  end
end
