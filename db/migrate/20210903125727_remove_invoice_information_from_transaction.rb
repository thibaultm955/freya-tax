class RemoveInvoiceInformationFromTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :invoice_number

    
  end
end
