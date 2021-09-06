class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.date :invoice_date
      t.date :payment_date
      t.string :invoice_number
      t.references :customer

      t.timestamps
    end
  end
end
