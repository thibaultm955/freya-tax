class RemoveBoxTaxCode < ActiveRecord::Migration[6.0]
  def change
    drop_table  :box_tax_codes
  end
end
