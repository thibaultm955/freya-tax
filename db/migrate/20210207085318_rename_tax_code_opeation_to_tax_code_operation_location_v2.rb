class RenameTaxCodeOpeationToTaxCodeOperationLocationV2 < ActiveRecord::Migration[6.0]
  def change
    rename_table :tax_code_operations, :tax_code_operation_locations
  end
end
