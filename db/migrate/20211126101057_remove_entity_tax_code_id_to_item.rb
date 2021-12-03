class RemoveEntityTaxCodeIdToItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :entity_tax_code_id
  end
end
