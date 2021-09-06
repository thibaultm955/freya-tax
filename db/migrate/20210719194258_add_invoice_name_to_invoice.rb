class AddInvoiceNameToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :invoice_name, :string
  end
end
