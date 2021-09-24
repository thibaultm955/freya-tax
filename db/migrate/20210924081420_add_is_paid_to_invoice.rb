class AddIsPaidToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :is_paid, :boolean
  end
end
