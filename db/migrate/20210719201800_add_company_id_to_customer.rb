class AddCompanyIdToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :customers, :company, null: false, foreign_key: true
  end
end
