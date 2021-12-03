class AddTaxCodeInfoToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_reference :invoices, :tax_code_operation_side,  foreign_key: true
    add_reference :invoices, :tax_code_operation_location, foreign_key: true
  end
end
