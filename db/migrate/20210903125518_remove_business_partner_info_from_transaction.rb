class RemoveBusinessPartnerInfoFromTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :business_partner_name
    remove_column :transactions, :invoice_date
    remove_column :transactions, :business_partner_vat_number

  end
end
