class Addfields2ToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :business_partner_name, :string
    add_column :transactions, :business_partner_vat_number, :string
  end
end
