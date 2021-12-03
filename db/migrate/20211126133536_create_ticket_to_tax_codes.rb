class CreateTicketToTaxCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_to_tax_codes do |t|
      t.references :tax_code_operation_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
