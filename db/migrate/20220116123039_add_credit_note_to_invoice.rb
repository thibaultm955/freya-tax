class AddCreditNoteToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :is_credit_note, :boolean
  end
end
