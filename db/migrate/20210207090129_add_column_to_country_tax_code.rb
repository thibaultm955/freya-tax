class AddColumnToCountryTaxCode < ActiveRecord::Migration[6.0]
  def change
    add_reference :country_tax_codes, :tax_code_operation_location, null: false, foreign_key: true
    add_reference :country_tax_codes, :tax_code_operation_side, null: false, foreign_key: true
    add_reference :country_tax_codes, :tax_code_operation_type, null: false, foreign_key: true
    add_reference :country_tax_codes, :tax_code_operation_rate, null: false, foreign_key: true
    
  end
end
