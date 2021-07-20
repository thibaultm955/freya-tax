class AddInvoiceToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :invoice, foreign_key: true

  end
end
