class AddEntityIdToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_reference :invoices, :entity, null: false, foreign_key: true
  end
end
