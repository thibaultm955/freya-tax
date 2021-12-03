class AddNameToTicketToTaxCode < ActiveRecord::Migration[6.0]
  def change
    add_column :ticket_to_tax_codes, :name, :string
  end
end
