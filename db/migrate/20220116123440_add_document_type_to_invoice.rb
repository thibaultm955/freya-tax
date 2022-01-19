class AddDocumentTypeToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_reference :invoices, :document_type, null: false, foreign_key: true
    remove_column :invoices, :is_credit_note
  end
end
