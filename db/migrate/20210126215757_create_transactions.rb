class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :invoice_number
      t.date :invoice_date
      t.string :tax_code
      t.float :vat_amount
      t.float :net_amount
      t.float :total_amount

      t.timestamps
    end
  end
end
